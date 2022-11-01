output "VPC-ID" {
  description = "VPC ID created"
  value       = aws_vpc.myvpc.id
}

output "VPC-NAME" {
  description = "VPC ID created"
  value       = aws_vpc.myvpc.tags.Name
}

output "PUBLIC-SECURITY-GROUP" {
  description = "Public SG"
  value       = aws_security_group.public-sg.id
}

output "PUBLIC-SUBNET1-ID" {
  description = "Public Subnet1"
  value       = aws_subnet.public-subnet1.id
}

output "PUBLIC-SUBNET2-ID" {
  description = "Public Subnet2"
  value       = aws_subnet.public-subnet2.id
}

output "PUBLIC-SUBNET3-ID" {
  description = "Public Subnet3"
  value       = aws_subnet.public-subnet3.id
}

output "PUBLIC-SUBNET1-NAME" {
  description = "Public Subnet1"
  value       = aws_subnet.public-subnet1.tags.Name
}

output "PUBLIC-SUBNET2-NAME" {
  description = "Public Subnet2"
  value       = aws_subnet.public-subnet2.tags.Name
}

output "PUBLIC-SUBNET3-NAME" {
  description = "Public Subnet3"
  value       = aws_subnet.public-subnet3.tags.Name
}
