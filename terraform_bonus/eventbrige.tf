module "nba_game_updates_eventbridge" {
  source              = "./modules/eventbridge"
  schedule_expression = "rate(1 hour)"
  lambda_function_arn = aws_lambda_function.nba_game_updates.arn
  rule_name           = "nba-game-updates-schedule"
  description         = "Trigger NBA game updates Lambda function on schedule"
  environment_tag     = var.environment_tag
  target_id           = "nba_game_updates_lambda"
  lambda_function_name = aws_lambda_function.nba_game_updates.function_name
}