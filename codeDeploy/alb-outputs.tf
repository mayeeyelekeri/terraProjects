output "ALB-DNS-Name" {
  description = "ALB Dns name"
  value       = aws_lb.alb.dns_name
}

output "ALB-DNS-Name-Private" {
  description = "ALB Dns name"
  value       = aws_lb.alb.dns_name
}

output "Web-Servers" {
  description = "Web Servers IPs"
  value       = values(aws_instance.webservers)[*].public_ip
} 

output "private-subnets" {
	value	  = values(aws_subnet.private-subnets)[*].cidr_block
} 

output "private-subnet-keys" {
	value	  = keys(aws_subnet.private-subnets)[*]
} 