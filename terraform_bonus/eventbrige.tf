resource "aws_cloudwatch_event_rule" "nba_game_updates_rule" {
  name                = "nba-game-updates-schedule"
  description         = "Trigger NBA game updates Lambda function on schedule"
  schedule_expression = "rate(1 hour)"
  
  tags = {
    Environment = var.environment_tag
    Name        = "nba-game-updates-schedule"
  }
}

resource "aws_cloudwatch_event_target" "nba_game_updates_target" {
  rule      = aws_cloudwatch_event_rule.nba_game_updates_rule.name
  target_id = "nba_game_updates_lambda"
  arn       = aws_lambda_function.nba_game_updates.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.nba_game_updates.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.nba_game_updates_rule.arn
}