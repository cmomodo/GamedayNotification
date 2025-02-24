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