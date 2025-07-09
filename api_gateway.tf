# api_gateway.tf

# Create HTTP API
resource "aws_apigatewayv2_api" "shortener_api" {
  name          = "shortener-api"
  protocol_type = "HTTP"

    cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["OPTIONS", "POST", "GET"]
    allow_headers = ["Content-Type", "Authorization"]
    max_age       = 3600
  }
}

# Lambda integration
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.shortener_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.shortener_lambda.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

# Route for POST /shorten
resource "aws_apigatewayv2_route" "shorten_route" {
  api_id    = aws_apigatewayv2_api.shortener_api.id
  route_key = "POST /shorten"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Route for GET /{code}
resource "aws_apigatewayv2_route" "redirect_route" {
  api_id    = aws_apigatewayv2_api.shortener_api.id
  route_key = "GET /{code}"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Route for GET /
resource "aws_apigatewayv2_route" "root_route" {
  api_id    = aws_apigatewayv2_api.shortener_api.id
  route_key = "GET /"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Deploy stage
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.shortener_api.id
  name        = "$default"
  auto_deploy = true
}

# Allow API Gateway to invoke Lambda
resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shortener_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.shortener_api.execution_arn}/*/*"
}
