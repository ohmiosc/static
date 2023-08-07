data "aws_caller_identity" "current" {}

output "account_id" {
  value = local.account_id
}

#data "aws_iam_policy_document" "s3_policy" {
#  statement {
#    actions   = ["s3:GetObject"]
#    resources = ["${aws_s3_bucket.bk-plugins.arn}/*"]#
#
#    principals {
#      type        = "AWS"
#      identifiers = [aws_cloudfront_origin_access_identity.oai_plugins.iam_arn]
#    }
#  }
#}

resource "aws_s3_bucket_policy" "cf_bucket-policy" {
  bucket = aws_s3_bucket.bk-plugins.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "Cloudfront-s3-sPolicy"
    Statement = [
      {
        Sid    = "AWSConfigBucketSecureTransport"
        Effect = "Deny"
        Principal = {
          AWS = data.aws_caller_identity.current.account_id
        }
        Action   = ["s3:*"]
        Resource = ["${aws_s3_bucket.bk-plugins.arn}/*", "${aws_s3_bucket.bk-plugins.arn}"]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid    = "denyOutdatedTLS"
        Effect = "Deny"
        Principal = "*"
        Action   = ["s3:*"]
        Resource = ["${aws_s3_bucket.bk-plugins.arn}/*", "${aws_s3_bucket.bk-plugins.arn}"]
        Condition = {
          NumericLessThan = {
            "s3:TlsVersion" = "1.2"
          }
        }
      },
      {
        Sid    = "AWSConfigBucketcloudfront"
        Effect = "Allow"
        Principal = {
          AWS = aws_cloudfront_origin_access_identity.oai_plugins.iam_arn
        }
        Action   = ["s3:GetObject"]
        Resource = ["${aws_s3_bucket.bk-plugins.arn}/*"]
      }
    ]
  })
}


#resource "aws_s3_bucket_policy" "s3_policy_plugins" {
#  bucket = aws_s3_bucket.bk-plugins.id
#  policy = data.aws_iam_policy_document.s3_policy.json
#}

resource "aws_s3_bucket" "bk-plugins" {

  #bucket = "${var.environment}.${var.product}.${var.domain}-${local.account_id}"
  bucket = "${var.product}.${var.domain}.${local.account_id}"
}

resource "aws_s3_bucket_versioning" "versioning_plugins" {
  bucket = aws_s3_bucket.bk-plugins.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "access_public" {
  bucket = aws_s3_bucket.bk-plugins.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  s3_origin_id = "myS3Origin"
  account_id   = data.aws_caller_identity.current.account_id
}
