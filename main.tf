# main.tf

# This file defines the AWS provider and region
provider "aws" {
  region = var.aws_region
}

# Get information about the current AWS account
data "aws_caller_identity" "current" {}
