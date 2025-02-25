resource "aws_lambda_function" "nba_game_updates" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = var.lambda_function_name
  description      = "Lambda function to fetch NBA game updates and publish to SNS"
  role             = aws_iam_role.lambda_role.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  
  runtime     = var.lambda_runtime
  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory_size
  
  environment {
    variables = {
      NBA_GAME_SECRET_NAME = aws_secretsmanager_secret.nba_game.name
      SNS_TOPIC_ARN = "arn:aws:sns:eu-west-2:449095351082:my-custom-nba-topic"
    }
  }

  tags = {
    Environment = var.environment_tag
    Name        = var.lambda_function_name
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_zip"
  output_path = "${path.module}/my_deployment_package.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.lambda_function_name}_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment_tag
    Name        = "${var.lambda_function_name}_role"
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.lambda_function_name}_policy"
  description = "Policy for ${var.lambda_function_name} Lambda function"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          aws_secretsmanager_secret.nba_game.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = [
          aws_kms_key.nba_secret_key.arn
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "sns:Publish"
        ]
        Resource = aws_sns_topic.NBA_Game_Updates.arn
      }
    ]
  })

  tags = {
    Environment = var.environment_tag
    Name        = "${var.lambda_function_name}_policy"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.nba_game_updates.function_name}"
  retention_in_days = var.lambda_log_retention

  tags = {
    Environment = var.environment_tag
    Name        = "${var.lambda_function_name}_logs"
  }
}
