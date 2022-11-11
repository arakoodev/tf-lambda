output "custom_domain_api" {
  value = "https://${aws_apigatewayv2_api_mapping.api.domain_name}"
}