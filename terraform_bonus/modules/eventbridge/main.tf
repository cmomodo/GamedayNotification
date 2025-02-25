resource "aws_cloudwatch_event_rule" "nba_game_updates_rule" {
  name                = "nba-game-updates-schedule"
  description         = "Trigger Lambda function to fetch NBA game updates"
  schedule_expression = "rate(1 day)"  # Adjust the schedule as needed

  tags = {
    Environment = var.environment_tag
    Name        = var.rule_name
  }
}

resource "aws_cloudwatch_event_target" "nba_game_updates_target" {
  rule      = aws_cloudwatch_event_rule.nba_game_updates_rule.name
  target_id = "nba_game_updates_lambda"
  arn       = var.lambda_function_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.nba_game_updates_rule.arn
}
