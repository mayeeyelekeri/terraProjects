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

output "PRIVATE-SECURITY-GROUP" {
  description = "Private SG"
  value       = aws_security_group.private-sg.id
}

output "PUBLIC-SUBNET-NAME" {
  description = "Public Subnet"
  value       = aws_subnet.mysubnet["public"].id
} 

output "PRIVATE-SUBNET-NAME" {
  description = "Private Subnet"
  value       = aws_subnet.mysubnet["private"].id
} 
