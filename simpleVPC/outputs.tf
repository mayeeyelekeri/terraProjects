output "VPC-ID" {
  description = "VPC ID created"
  value       = module.vpc-module.VPC-ID
}

output "PUBLIC-SECURIY-GROUP" {
  description = "Public SG"
  value       = module.vpc-module.PUBLIC-SECURIY-GROUP
}

output "PRIVATE-SECURIY-GROUP" {
  description = "Private SG"
  value       = module.vpc-module.PRIVATE-SECURITY-GROUP
}

output "PUBLIC-EC2-INSTANCE-ID" {
  description = "Public instance ID"
  value       = module.ec2-module.EC2-INSTANCE-ID
}

output "EC2-INSTANCE-PUBLIC-IP" {
  value     = module.ec2-module.EC2-INSTANCE-PUBLIC-IP
}
 
output "EC2-KEY-NAME" {
  description = "EC2 Instance Key Name"
  value       = module.ec2-module.EC2-KEY-NAME
}



output "Project_Name" {
  description = "Project Name"
  value       = var.project_name
}