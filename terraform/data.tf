data "aws_caller_identity" "current" {}
data "aws_iam_session_context" "current" {
  arn = data.aws_caller_identity.current.arn
}

data "aws_iam_policy_document" "combined" {
  source_policy_documents = compact([
    data.aws_iam_policy_document.administration.json,
    data.aws_iam_policy_document.deny_insecure_transport.json,
    data.aws_iam_policy_document.require_latest_tls.json,
  ])
}

data "aws_iam_policy_document" "administration" {
  statement {
    sid = "S3BucketAdministration"

    effect = "Deny"

    actions = [
      "s3:DeleteBucket",
      "s3:DeleteBucketPolicy",
      "s3:PutBucketPolicy",
      "s3:PutBucketPublicAccessBlock",
      "s3:PutBucketTagging",
      "s3:PutBucketVersioning",
      "s3:PutEncryptionConfiguration",
      "s3:PutLifecycleConfiguration"
    ]

    resources = [
      aws_s3_bucket.this.arn,
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "ArnNotEquals"
      variable = "aws:PrincipalArn"
      values = [
        data.aws_iam_session_context.current.issuer_arn,
      ]
    }
  }
}

data "aws_iam_policy_document" "deny_insecure_transport" {
  statement {
    sid     = "denyInsecureTransport"
    effect  = "Deny"
    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

data "aws_iam_policy_document" "require_latest_tls" {
  statement {
    sid     = "denyOutdatedTLS"
    effect  = "Deny"
    actions = ["s3:*"]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"
      values   = ["1.2"]
    }
  }
}
