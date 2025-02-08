terraform {
  backend "s3" {
    # keep-sorted start
    acl     = "bucket-owner-full-control"
    bucket  = "ruzickap-gha-test-terraform-state"
    encrypt = true
    key     = "ruzickap-gha-test-terraform-state.tfstate"
    region  = "us-east-1"
    # keep-sorted end
  }
  required_providers {
    # keep-sorted start block=yes
    aws = {
      source  = "hashicorp/aws"
      version = "5.84.0"
    }
    # keep-sorted end
  }
  required_version = "~> 1.5"
}

locals {
  region           = "us-east-1"
  name             = "ruzickap-gha-test-bucket"
  object_ownership = "BucketOwnerEnforced"
}

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      Environment = "Dev"
      Owner       = "ruzickap"
      GitHub      = "https://github.com/ruzickap/gha-test/tree/main/terraform"
    }
  }
}

# trivy:ignore:AVD-AWS-0089 trivy:ignore:AVD-AWS-0132
resource "aws_s3_bucket" "this" {
  #checkov:skip=CKV_AWS_144: Ensure that S3 bucket has cross-region replication enabled
  #checkov:skip=CKV_AWS_145: Ensure that S3 buckets are encrypted with KMS by default
  #checkov:skip=CKV_AWS_18: Ensure the S3 bucket has access logging enabled
  #checkov:skip=CKV2_AWS_61: Ensure that an S3 bucket has a lifecycle configuration
  #checkov:skip=CKV2_AWS_62: Ensure S3 buckets should have event notifications enabled
  bucket              = local.name
  object_lock_enabled = true
  force_destroy       = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = local.object_ownership # Recommended by AWS and disables ACLs
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# Only if object_ownership is not BucketOwnerEnforced, then set the ACL to private
resource "aws_s3_bucket_acl" "this" {
  count = local.object_ownership != "BucketOwnerEnforced" ? 1 : 0

  bucket = aws_s3_bucket.this.id

  acl = "private"

  depends_on = [aws_s3_bucket_ownership_controls.this]
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.combined.json
}
