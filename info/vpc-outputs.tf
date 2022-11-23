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

output "public-subnet-names" {
	value	  = keys(aws_subnet.public-subnets)[*]
} 

output "public-subnet-1" {
	value	  = values(aws_subnet.public-subnets)[1].id
} 