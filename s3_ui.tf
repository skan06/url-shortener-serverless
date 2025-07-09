# s3_ui.tf

# Create the S3 bucket for hosting the frontend static website
resource "aws_s3_bucket" "frontend_ui" {
  bucket        = "url-shortener-frontend-skander"
  force_destroy = true

  tags = {
    Name = "URL Shortener Frontend Bucket"
  }
}

# Enable static website hosting on the bucket
resource "aws_s3_bucket_website_configuration" "frontend_config" {
  bucket = aws_s3_bucket.frontend_ui.id

  index_document {
    suffix = "index.html"
  }
}

# Disable public access blocking so that we can apply a public-read bucket policy
resource "aws_s3_bucket_public_access_block" "frontend_public_access" {
  bucket = aws_s3_bucket.frontend_ui.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Set bucket policy to allow public read access to all objects
resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend_ui.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = ["s3:GetObject"],
        Resource  = "${aws_s3_bucket.frontend_ui.arn}/*"
      }
    ]
  })
}

# Upload the index.html file to the bucket
resource "aws_s3_object" "frontend_index" {
  bucket       = aws_s3_bucket.frontend_ui.id
  key          = "index.html"
  source       = "frontend/index.html"
  content_type = "text/html"
}

# Upload the style.css file to the bucket
resource "aws_s3_object" "frontend_css" {
  bucket       = aws_s3_bucket.frontend_ui.id
  key          = "style.css"
  source       = "frontend/style.css"
  content_type = "text/css"
}
