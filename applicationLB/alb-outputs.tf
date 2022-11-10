output "ec2-instance1-public-IP" {
  description = "EC2 Instance Public IP Address"
  value       = aws_instance.webserver1.public_ip
} 

output "ec2-instance2-public-IP" {
  description = "EC2 Instance Public IP Address"
  value       = aws_instance.webserver2.public_ip
}

output "ec2-instance3-public-IP" {
  description = "EC2 Instance Public IP Address"
  value       = aws_instance.webserver3.public_ip
}

output "ALB-DNS-Name" {
  description = "ALB Dns name"
  value       = aws_lb.alb.dns_name
}

