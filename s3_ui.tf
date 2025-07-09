#s3-ui.tf

# Create S3 bucket for hosting frontend static website
resource "aws_s3_bucket" "frontend_ui" {
  bucket = "url-shortener-frontend-skander"
  force_destroy = true
}

# Enable static website hosting on the bucket
resource "aws_s3_bucket_website_configuration" "frontend_config" {
  bucket = aws_s3_bucket.frontend_ui.id

  index_document {
    suffix = "index.html"
  }
}

# Public access block configuration - disable blocking public policies (allow public read)
resource "aws_s3_bucket_public_access_block" "frontend_public_access" {
  bucket = aws_s3_bucket.frontend_ui.id

  block_public_acls       = true
  block_public_policy     = false   # Allow public bucket policies
  ignore_public_acls      = true
  restrict_public_buckets = false
}

# Bucket policy to allow public read access on all objects in the bucket
resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend_ui.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = "*"
      Action = ["s3:GetObject"]
      Resource = "${aws_s3_bucket.frontend_ui.arn}/*"
    }]
  })
}

# Upload index.html file to the bucket (update path if needed)
resource "aws_s3_object" "frontend_index" {
  bucket = aws_s3_bucket.frontend_ui.id
  key    = "index.html"
  source = "frontend/index.html" # Local path to your index.html file
  content_type = "text/html"
}

# Upload style.css file to the bucket (update path if needed)
resource "aws_s3_object" "frontend_css" {
  bucket = aws_s3_bucket.frontend_ui.id
  key    = "style.css"
  source = "frontend/style.css" # Local path to your style.css file
  content_type = "text/css"
}

