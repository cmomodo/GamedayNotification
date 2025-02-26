terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "nba_game" {
  cidr_block = var.cidr_block

  tags = {
    Name = "NBA Game VPC"
  }
}

# module "nba_game_updates_eventbridge" {
#   source          = "./modules/eventbridge"
#   environment_tag = "dev"
#   rule_name       = "nba-game-updates-rule"
#   lambda_function_arn = aws_lambda_function.nba_game_updates.arn
#   lambda_function_name = aws_lambda_function.nba_game_updates.function_name
# }