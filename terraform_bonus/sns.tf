resource "aws_sns_topic" "NBA_Game_Updates" {
  name         = var.sns_topic_name
  display_name = var.sns_topic_display_name
  tags = {
    Environment = var.environment_tag
  }
}

# Subscription for phone number
resource "aws_sns_topic_subscription" "phone_number_sub" {
  topic_arn = aws_sns_topic.NBA_Game_Updates.arn
  protocol  = "sms"
  endpoint  = var.phone_number
}

# Subscription for email
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.NBA_Game_Updates.arn
  protocol  = "email"
  endpoint  = var.email_address
}