region      = "eu-west-2"
cidr_block = "10.0.0.0/16"
nba_api_key = "addec72e5c9346998e893bcbf40d390d"
sns_topic_name         = "my-custom-nba-topic"
sns_topic_display_name = "My Custom NBA Game Updates"
environment_tag        = "Staging"
email_address = "<EMAIL>"
phone_number = "<PHONE_NUMBER>"
s3_bucket_name = "<BUCKET_NAME>"
iam_user_arn   = "<ARN>"

# Lambda function configuration
lambda_function_name = "nba_game_updates"
lambda_runtime = "python3.9"
lambda_timeout = 30
lambda_memory_size = 256
lambda_log_retention = 14