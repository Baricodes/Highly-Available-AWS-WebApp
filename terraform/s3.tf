# ------------------------------------------------------------------------------
# S3 bucket for static assets, logs, backups, and deployment artifacts
# ------------------------------------------------------------------------------

resource "aws_s3_bucket" "assets" {
  bucket = var.s3_assets_bucket_name

  tags = {
    Name = var.s3_assets_bucket_name
  }
}

resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "assets" {
  bucket = aws_s3_bucket.assets.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets" {
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

output "s3_assets_bucket_name" {
  description = "Name of the S3 bucket for static assets, logs, backups, and deployment artifacts"
  value       = aws_s3_bucket.assets.id
}

output "s3_assets_bucket_arn" {
  description = "ARN of the S3 bucket for static assets, logs, backups, and deployment artifacts"
  value       = aws_s3_bucket.assets.arn
}
