output "EC2-INSTANCE-ID" {
  description = "EC2 Instance ID"
  value       = aws_instance.webserver.id
}