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

output "PUBLIC1-SUBNET1-NAME" {
  description = "Public Subnet"
  value       = aws_subnet.mysubnet["subnet1"].tags.Name
} 

output "PUBLIC-SUBNET2-NAME" {
  description = "Private Subnet"
  value       = aws_subnet.mysubnet["subnet2"].tags.Name
} 

output "PUBLIC-SUBNET3-NAME" {
  description = "Private Subnet"
  value       = aws_subnet.mysubnet["subnet3"].tags.Name
} 