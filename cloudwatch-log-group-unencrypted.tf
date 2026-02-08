terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.31.0"
    }
  }
  required_version = "~> 1.11"
}

provider "aws" {
  region = "us-east-1"
}

# Misconfiguration: CloudWatch Log Group without KMS encryption
# trivy:ignore:AVD-AWS-0017
resource "aws_cloudwatch_log_group" "unencrypted" {
  #checkov:skip=CKV_AWS_158:Test resource intentionally left unencrypted
  name              = "unencrypted-log-group"
  retention_in_days = 365
}
