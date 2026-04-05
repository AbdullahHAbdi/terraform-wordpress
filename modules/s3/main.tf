# S3 Bucket
resource "aws_s3_bucket" "wordpress_media" {
  bucket = "${var.project_name}-media-${random_id.suffix.hex}"

  tags = { Name = "${var.project_name}-media" }
}

# Random suffix to ensure unique bucket name
resource "random_id" "suffix" {
  byte_length = 4
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "wordpress_media" {
  bucket = aws_s3_bucket.wordpress_media.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "wordpress_media" {
  bucket = aws_s3_bucket.wordpress_media.id

  versioning_configuration {
    status = "Enabled"
  }
}