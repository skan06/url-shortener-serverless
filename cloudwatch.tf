# cloudwatch.tf

# Create CloudWatch log group for Lambda
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/shortener-function"
  retention_in_days = 7
}
