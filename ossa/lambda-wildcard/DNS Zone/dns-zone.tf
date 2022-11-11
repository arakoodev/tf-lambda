# Create the dns zone
resource "aws_route53_zone" "my_hosted_zone" {
  name = var.domain_name
}