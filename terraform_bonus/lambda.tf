resource "aws_lambda_function" "nba_game_updates" {
  function_name = "nba-game-updates-lambda"
  description   = "Fetch NBA game updates"
  handler       = "index.handler"
  runtime       = "nodejs16.x"
  timeout       = 30
  memory_size   = 128

  # The path to the function's deployment package inside the local filesystem.
  filename      = "lambda_function_payload.zip"

  # Source code archive deployment configuration.
  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  # The IAM role assumed by the Lambda function.
  role = aws_iam_role.lambda_role.arn

  tags = {
    Environment = "dev"
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "nba-game-updates-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid = ""
      }
    ]
  })

  tags = {
    Environment = "dev"
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "nba-game-updates-lambda-policy"
  description = "IAM policy for Lambda function to fetch NBA game updates"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*",
        Effect   = "Allow"
      }
    ]
  })

  tags = {
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}
