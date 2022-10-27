output "EC2-INSTANCE-ID" {
  description = "EC2 Instance ID"
  value       = aws_instance.webserver.id
}

output "EC2-INSTANCE-PUBLIC-IP" {
  description = "EC2 Instance Public IP Address"
  value       = aws_instance.webserver.public_ip
} 

output "EC2-KEY-NAME" {
  description = "EC2 Instance Key Name"
  value       = aws_instance.webserver.key_name
}

# ------- VPC outputs --------------
output "VPC-ID" {
  description = "VPC ID"
  value       = module.vpc-module.VPC-ID
}

output "PUBLIC-SECURITY-GROUP" {
  description = "VPC ID"
  value       = module.vpc-module.PUBLIC-SECURITY-GROUP
}

output "PRIVATE-SECURITY-GROUP" {
  description = "VPC ID"
  value       = module.vpc-module.PRIVATE-SECURITY-GROUP
}

/*
output "EC2-KEY-FILENAME" {
  description = "EC2 Instance Key File Name"
  value       = aws_instance.webserver.filename
} */ 