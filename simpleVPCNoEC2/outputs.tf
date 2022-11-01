output "VPC-NAME" {
  description = "VPC Name"
  value       = module.vpc-module.VPC-NAME
}

output "PUBLIC-SUBNET-NAME" {
  description = "Public Subnet Name"
  value       = module.vpc-module.PUBLIC-SUBNET-NAME
}

output "PRIVATE-SUBNET-NAME" {
  description = "Private Subnet Name"
  value       = module.vpc-module.PRIVATE-SUBNET-NAME
}

output "Project_Name" {
  description = "Project Name"
  value       = var.project_name
}
