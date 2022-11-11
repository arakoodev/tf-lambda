// Hosted Zone name
variable "DOMAIN_NAME" {
  type = string
}

// API Gateway name
variable "API_GATEWAY_NAME" {
  type = string
}

locals {
  domain_name      = var.DOMAIN_NAME
  hosted_zone_name = "lambda.${local.domain_name}"
  api_gateway_name = var.API_GATEWAY_NAME
}