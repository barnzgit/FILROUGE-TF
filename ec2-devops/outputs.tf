output "nom_instance" {
  description = "Nom de l'instance"
  value       = var.ec2_nom
}

output "type_instance" {
  description = "type de l'instance"
  value       = var.instance_type
}

output "security_groups" {
  description = "security group"
  value       = module.sg.security_group_id
}

output "script" {
  description = "type de l'instance"
  value       = var.user_data
}