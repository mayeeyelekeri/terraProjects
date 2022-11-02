output "EC2-INSTANCE-ID" {
  description = "EC2 Instance ID"
  value       = aws_instance.webserver.id
}

output "EC2-INSTANCE-PUBLIC-IP" {
  description = "EC2 Instance Public IP Address"
  value       = aws_instance.webserver.public_ip
} 

output "EC2-DB-INSTANCE-PRIVATE-IP" {
  description = "EC2 Instance DB Instance Private IP Address"
  value       = aws_instance.dbserver.private_ip
}

output "EC2-KEY-NAME" {
  description = "EC2 Instance Key Name"
  value       = aws_instance.webserver.key_name
}

