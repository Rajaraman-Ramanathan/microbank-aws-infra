output "cluster_role_arn" {
  description = "EKS cluster IAM role ARN"
  value       = module.cluster_role.arn
}

output "node_role_arn" {
  description = "EKS worker node IAM role ARN"
  value       = module.node_role.arn
}