output "VPC-NAME" {
  description = "VPC Name"
  value       = module.ec2-module.VPC-NAME
}

output "PUBLIC-SUBNET-NAME" {
  description = "Public Subnet Name"
  value       = module.ec2-module.PUBLIC-SUBNET-NAME
}

output "PRIVATE-SUBNET-NAME" {
  description = "Private Subnet Name"
  value       = module.ec2-module.PRIVATE-SUBNET-NAME
}

output "Project_Name" {
  description = "Project Name"
  value       = var.project_name
}


# ------- EC2 Output ------- 
output "PUBLIC-SECURIY-GROUP" {
  description = "Public SG"
  value       = module.ec2-module.PUBLIC-SECURITY-GROUP
}

output "PRIVATE-SECURIY-GROUP" {
  description = "Private SG"
  value       = module.ec2-module.PRIVATE-SECURITY-GROUP
}

output "PUBLIC-EC2-INSTANCE-ID" {
  description = "Public instance ID"
  value       = module.ec2-module.EC2-INSTANCE-ID
}

output "EC2-INSTANCE-PUBLIC-IP" {
  value     = module.ec2-module.EC2-INSTANCE-PUBLIC-IP
}
 
output "EC2-DB-INSTANCE-PRIVATE-IP" {
  value     = module.ec2-module.EC2-DB-INSTANCE-PRIVATE-IP
}

output "EC2-KEY-NAME" {
  description = "EC2 Instance Key Name"
  value       = module.ec2-module.EC2-KEY-NAME
} 

