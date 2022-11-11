output "nameservers" {
  description = "nameservers to add on namecheap"
  value       = aws_route53_zone.my_hosted_zone.name_servers
}
output "zone_id" {
  description = "dns zone id"
  value       = aws_route53_zone.my_hosted_zone.zone_id
}
