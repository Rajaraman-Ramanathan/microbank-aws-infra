output "public_zone_id" {
  description = "Public Route53 hosted zone ID"
  value       = module.public_zone.zone_id
}

output "public_zone_arn" {
  description = "Public Route53 hosted zone ARN"
  value       = module.public_zone.zone_arn
}

output "public_zone_name_servers" {
  description = "Public Route53 name servers"
  value       = module.public_zone.name_servers
}

output "private_zone_id" {
  description = "Private Route53 hosted zone ID"
  value       = module.private_zone.zone_id
}

output "private_zone_arn" {
  description = "Private Route53 hosted zone ARN"
  value       = module.private_zone.zone_arn
}