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
  value       = aws_key_pair.generated-key.key_name
}

output "EC2-KEY-FILENAME" {
  description = "EC2 Instance Key File Name"
  value       = local_file.ssh_key.filename
}