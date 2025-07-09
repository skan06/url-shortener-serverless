# lambda.tf

# Create Lambda function
resource "aws_lambda_function" "shortener_lambda" {
  function_name = "shortener-function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  filename      = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  role          = aws_iam_role.lambda_exec_role.arn

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.url_table.name
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_logs]
}
