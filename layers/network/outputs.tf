output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs for EKS"
  value       = module.subnets.private_subnet_ids
}

output "db_subnet_ids" {
  description = "Private subnet IDs for RDS"
  value       = module.subnets.db_subnet_ids
}

output "eks_cluster_sg_id" {
  description = "EKS cluster security group ID"
  value       = module.eks_cluster_sg.security_group_id
}

output "eks_node_sg_id" {
  description = "EKS node security group ID"
  value       = module.eks_node_sg.security_group_id
}

output "keycloak_sg_id" {
  description = "Keycloak security group ID"
  value       = module.keycloak_sg.security_group_id
}

output "rds_sg_id" {
  description = "RDS security group ID"
  value       = module.rds_sg.security_group_id
}

output "redis_sg_id" {
  description = "Redis security group ID"
  value       = module.redis_sg.security_group_id
}

output "amazonmq_sg_id" {
  description = "AmazonMQ security group ID"
  value       = module.amazonmq_sg.security_group_id
}

output "alb_public_sg_id" {
  description = "ALB public security group ID"
  value       = module.alb_public_sg.security_group_id
}

output "vpce_sg_id" {
  description = "VPC endpoint security group ID"
  value       = module.vpce_sg.security_group_id
}