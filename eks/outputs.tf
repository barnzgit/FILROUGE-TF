output "cluster_endpoint" {
  description = "Endpoint du control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids du cluster"
  value       = module.eks.cluster_security_group_id
}


output "cluster_name" {
  description = "Nom du cluster"
  value       = module.eks.cluster_name
}