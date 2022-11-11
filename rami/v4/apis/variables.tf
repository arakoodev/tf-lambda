variable "DOMAIN_NAME" {
  type        = string
  description = "Domain name"
}

// Fetch Route 53 Hosted Zone
data "aws_route53_zone" "this" {
  name = local.hosted_zone_name
}

// Fetch API Gateway
data "aws_api_gateway_rest_api" "this" {
  name = var.API_GATEWAY_NAME
}

# Fetch the generic certificate
data "aws_acm_certificate" "this" {
  domain = "*.${local.hosted_zone_name}"
}

variable "API_GATEWAY_NAME" {
  type        = string
  description = "Name of the API Gateway"
}

variable "FUNCTION_NAME" {
  type        = string
  description = "Name of the Lambda Function"
}

variable "ZIP_FILE_PATH" {
  type        = string
  description = "Path of the Lambda ZIP file"
}

// Format => filename.func_name (Python)
// Verify that there are different conventions for every language
variable "FUNCTION_HANDLER" {
  type        = string
  description = "Handler that should be triggered by the Lambda Function"
}

variable "FUNCTION_RUNTIME" {
  type        = string
  description = "Language and version bein used"
}

// Fetch Lambda's shared IAM Role
data "aws_iam_role" "lambda" {
  name = "lambda-funtions-shared-role"
}

variable "APIGW_METHOD" {
  type        = string
  description = "Method for the API Gateway Resource"
}

variable "APIGW_PATH" {
  type        = string
  description = "Name of the API Gateway Path"
}

locals {
  // Route 53 variables
  domain_name      = var.DOMAIN_NAME
  hosted_zone_name = "lambda.${local.domain_name}"

  // API Gateway variables
  api_gateway        = data.aws_api_gateway_rest_api.this
  api_gateway_method = var.APIGW_METHOD
  api_gateway_path   = var.APIGW_PATH

  // Lambda variables
  function_name              = var.FUNCTION_NAME
  zip_file_path              = var.ZIP_FILE_PATH
  lambda_shared_iam_role_arn = data.aws_iam_role.lambda.arn
  function_handler           = var.FUNCTION_HANDLER
  function_runtime           = var.FUNCTION_RUNTIME
}