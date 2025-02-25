resource "aws_cloudwatch_event_rule" "nba_game_updates_rule" {
  name                = var.rule_name
  description         = var.description
  schedule_expression = var.schedule_expression

  tags = {
    Environment = var.environment_tag
    Name        = var.rule_name
  }
}

resource "aws_cloudwatch_event_target" "nba_game_updates_target" {
  rule      = aws_cloudwatch_event_rule.nba_game_updates_rule.name
  target_id = var.target_id
  arn       = var.lambda_function_arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.nba_game_updates_rule.arn
}
