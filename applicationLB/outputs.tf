output "VPC-NAME" {
  description = "VPC Name"
  value       = module.ec2-module.VPC-NAME
}

output "PUBLIC-SUBNET1-NAME" {
  description = "Public Subnet Name"
  value       = module.ec2-module.PUBLIC-SUBNET1-NAME
}

output "PUBLIC-SUBNET3-NAME" {
  description = "Public Subnet Name"
  value       = module.ec2-module.PUBLIC-SUBNET3-NAME
}

output "PUBLIC-SUBNET2-NAME" {
  description = "Public Subnet Name"
  value       = module.ec2-module.PUBLIC-SUBNET2-NAME
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

output "EC2-INSTANCE-PUBLIC1-IP" {
  value     = module.ec2-module.EC2-INSTANCE-PUBLIC-IP1
}
 
output "EC2-INSTANCE-PUBLIC2-IP" {
  value     = module.ec2-module.EC2-INSTANCE-PUBLIC-IP2
}

output "EC2-INSTANCE-PUBLIC3-IP" {
  value     = module.ec2-module.EC2-INSTANCE-PUBLIC-IP2
}
output "EC2-KEY-NAME" {
  description = "EC2 Instance Key Name"
  value       = module.ec2-module.EC2-KEY-NAME
} 

output "ALB-TARGET-GROUP" {
  description = "EC2 Instance Key Name"
  value       = module.ec2-module.ALB-TARGET-GROUP
} 
