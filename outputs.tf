# outputs.tf

output "api_endpoint" {
  description = "API Gateway URL"
  value       = aws_apigatewayv2_api.shortener_api.api_endpoint
}

output "s3_website_url" {
  #description = "Frontend website URL"
  value       = aws_s3_bucket.frontend_ui.website_endpoint
}
