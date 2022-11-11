output "lambda_url" {
  value       = aws_lambda_function_url.this.function_url
  description = "Lambda Function URL"
}

output "cloudfront_url" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "CloudFront Distribution URL"
}

output "route53_url" {
  value       = "https://${aws_route53_record.this.name}"
  description = "Route 53 Record URL"
}