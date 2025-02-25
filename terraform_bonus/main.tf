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