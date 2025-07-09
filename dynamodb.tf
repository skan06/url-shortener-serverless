# dynamodb.tf

# DynamoDB table to store the short links
resource "aws_dynamodb_table" "url_table" {
  name         = "url-shortener"
  billing_mode = "PAY_PER_REQUEST" # Free tier compatible
  hash_key     = "code"

  attribute {
    name = "code"
    type = "S"
  }

  tags = {
    Name = "URLShortenerTable"
  }
}
