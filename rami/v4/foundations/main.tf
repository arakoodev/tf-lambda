// 1. Create Route 53 Hosted Zone
resource "aws_route53_zone" "this" {
  name = local.hosted_zone_name
}

// 2. Create a Record in the main's Domain Hosted Zone to delegate it domain.
data "aws_route53_zone" "main" {
  name = local.domain_name
}

resource "aws_route53_record" "ns_delegation" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = aws_route53_zone.this.name
  type    = "NS"
  ttl     = "60"
  records = aws_route53_zone.this.name_servers
}

// 3. Create API Gateway and it's stage
resource "aws_api_gateway_rest_api" "this" {
  name        = local.api_gateway_name
  description = "Exposes Lambda Functions"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

// 4. Create generic ACM Certificate
resource "aws_acm_certificate" "this" {
  domain_name       = "*.${local.hosted_zone_name}"
  validation_method = "DNS"
}

// 5. Validate ACM Certificate.
resource "aws_route53_record" "cert_dns_validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.this.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_dns_validation : record.fqdn]
}

// 6. Create shared IAM Role for Lamdba Functions
resource "aws_iam_role" "lambda" {
  name = "lambda-funtions-shared-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

// 7. Create permission to write logs and attach it to the role

resource "aws_iam_policy" "logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.logging.arn
}