output "EC2-INSTANCE-PUBLIC-IP1" {
  description = "EC2 Instance Public IP Address"
  value       = aws_instance.webserver1.public_ip
} 

output "EC2-INSTANCE-PUBLIC-IP2" {
  description = "EC2 Instance Public IP Address"
  value       = aws_instance.webserver2.public_ip
} 

output "EC2-INSTANCE-PUBLIC-IP3" {
  description = "EC2 Instance Public IP Address"
  value       = aws_instance.webserver3.public_ip
} 

output "EC2-KEY-NAME" {
  description = "EC2 Instance Key Name"
  value       = aws_instance.webserver1.key_name
}

# ------- VPC outputs --------------
output "VPC-ID" {
  description = "VPC ID"
  value       = module.vpc-module.VPC-ID
}

output "VPC-NAME" {
  description = "VPC Name"
  value       = module.vpc-module.VPC-NAME
}

output "PUBLIC-SUBNET1-NAME" {
  description = "VPC Name"
  value       = module.vpc-module.PUBLIC-SUBNET1-NAME
}

output "PUBLIC-SUBNET2-NAME" {
  description = "VPC Name"
  value       = module.vpc-module.PUBLIC-SUBNET2-NAME
}

output "PUBLIC-SUBNET3-NAME" {
  description = "VPC Name"
  value       = module.vpc-module.PUBLIC-SUBNET3-NAME
}

output "PUBLIC-SECURITY-GROUP" {
  description = "VPC ID"
  value       = module.vpc-module.PUBLIC-SECURITY-GROUP
}

output "ALB-TARGET-GROUP" {
  description = "ALB Target Group"
  value       = aws_lb_target_group.tg.tags.Name
}