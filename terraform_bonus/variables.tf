variable "region" {
  type    = string
  default = "us-east-2"
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "nba_api_key" {
  description = "API key for NBA API"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.nba_api_key) > 0
    error_message = "NBA API key must be provided."
  }
}

variable "sns_topic_name" {
  type        = string
  default     = "nba-game-updates-topic"
  description = "The name of the SNS topic"
}

variable "sns_topic_display_name" {
  type        = string
  default     = "NBA Game Updates Topic"
  description = "The display name of the SNS topic"
}

variable "environment_tag" {
  type        = string
  default     = "Production"
  description = "The environment tag for the SNS topic"
}

variable "email_address" {
  type        = string
  description = "Email address to subscribe to the SNS topic"
  validation {
    condition     = can(regex("^\\S+@\\S+\\.\\S+$", var.email_address))
    error_message = "Email address must be a valid format."
  }
}

variable "phone_number" {
  type        = string
  description = "Phone number to subscribe to the SNS topic"

  validation {
    condition     = can(regex("^\\+?[1-9]\\d{1,14}$", var.phone_number))
    error_message = "Phone number must be in a valid format."
  }
}

variable "s3_bucket_name" {
  type        = string
  default     = "nba_game-data"
  description = "The name of the S3 bucket"
}

variable "iam_user_arn" {
  type        = string
  default     = "arn:aws:iam::449095351082:user/lamin"
  description = "The ARN of the IAM user"
}

# Lambda function variables
variable "lambda_function_name" {
  type        = string
  default     = "nba_game_updates"
  description = "The name of the Lambda function"
}

variable "lambda_runtime" {
  type        = string
  default     = "python3.9"
  description = "The runtime for the Lambda function"
}

variable "lambda_timeout" {
  type        = number
  default     = 30
  description = "The timeout for the Lambda function in seconds"
}

variable "lambda_memory_size" {
  type        = number
  default     = 128
  description = "The memory size for the Lambda function in MB"
}

variable "lambda_log_retention" {
  type        = number
  default     = 14
  description = "The number of days to retain Lambda logs"
}