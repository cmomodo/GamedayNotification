variable "schedule_expression" {
  type        = string
  description = "The schedule expression for the EventBridge rule"
}

variable "lambda_function_arn" {
  type        = string
  description = "The ARN of the Lambda function to invoke"
}

variable "rule_name" {
  type        = string
  description = "The name of the EventBridge rule"
}

variable "description" {
  type        = string
  description = "The description of the EventBridge rule"
}

variable "environment_tag" {
  type        = string
  description = "The environment tag for the EventBridge rule"
}

variable "target_id" {
  type        = string
  description = "The ID of the EventBridge target"
}

variable "lambda_function_name" {
  type        = string
  description = "The name of the Lambda function"
}
