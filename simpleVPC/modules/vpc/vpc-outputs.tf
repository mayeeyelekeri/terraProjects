output "VPC-ID" {
  description = "VPC ID created"
  value       = aws_vpc.myvpc.id
}

output "PUBLIC-SECURIY-GROUP" {
  description = "Public SG"
  value       = aws_security_group.public-sg.id
}

output "PRIVATE-SECURIY-GROUP" {
  description = "Private SG"
  value       = aws_security_group.private-sg.id
}

output "PUBLIC-SUBNET-ID" {
  description = "Public Subnet"
  value       = aws_subnet.public-subnet.id
}