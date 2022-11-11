// 1. Create CloudWatch Log Group for Lambda Function.
resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = 7
  lifecycle {
    prevent_destroy = false
  }
}

// 2. Create Lambda Function.
resource "aws_lambda_function" "this" {
  function_name = local.function_name
  role          = local.lambda_shared_iam_role_arn

  filename = "${path.module}/${local.zip_file_path}"
  handler  = local.function_handler
  runtime  = local.function_runtime
}

resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}

// 3. Create API Gateway Resource and Method.
resource "aws_api_gateway_resource" "this" {
  /* parent_id   = data.aws_api_gateway_resource.version.id */
  parent_id   = local.api_gateway.root_resource_id
  path_part   = local.api_gateway_path
  rest_api_id = local.api_gateway.id
}

resource "aws_api_gateway_method" "this" {
  authorization = "NONE"
  http_method   = local.api_gateway_method
  resource_id   = aws_api_gateway_resource.this.id
  rest_api_id   = local.api_gateway.id
}

// 4. Create attachment with API Gateway
resource "aws_api_gateway_integration" "this" {
  rest_api_id             = local.api_gateway.id
  resource_id             = aws_api_gateway_resource.this.id
  http_method             = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.this.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  function_name = aws_lambda_function.this.function_name
  source_arn    = "${local.api_gateway.execution_arn}/*/*"

  action       = "lambda:InvokeFunction"
  statement_id = "AllowExecutionFromAPIGateway"
  principal    = "apigateway.amazonaws.com"
}


// 5. Create API Gateway deployment
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = local.api_gateway.id
  stage_name  = "main"

  depends_on = [
    aws_api_gateway_method.this,
    aws_api_gateway_integration.this
  ]
}

//  8. Create CloudFront Distribution.
resource "aws_cloudfront_distribution" "this" {
  origin {
    domain_name = trimsuffix(trimprefix(aws_api_gateway_deployment.this.invoke_url, "https://"), "/main")
    origin_id   = local.function_name
    origin_path = "/main/${local.api_gateway_path}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  aliases = ["${local.api_gateway_path}.${local.hosted_zone_name}"]

  enabled         = true
  is_ipv6_enabled = true
  comment         = "Exposing ${local.function_name} Lambda Function"

  default_cache_behavior {
    allowed_methods  = [local.api_gateway_method, "HEAD"]
    cached_methods   = [local.api_gateway_method, "HEAD"]
    target_origin_id = local.function_name

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  viewer_certificate {
    acm_certificate_arn = data.aws_acm_certificate.this.arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

//  9. Create Route 53 Record to CFD.
resource "aws_route53_record" "this" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${local.api_gateway_path}.${local.hosted_zone_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}