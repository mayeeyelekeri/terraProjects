
output "Web-Servers" {
  description = "Web Servers IPs"
  value       = aws_instance.jenkins-server.public_ip
} 

