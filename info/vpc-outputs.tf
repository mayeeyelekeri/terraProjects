output "VPC-ID" {
  description = "VPC ID created"
  value       = aws_vpc.myvpc.id
}

output "VPC-NAME" {
  description = "VPC ID created"
  value       = aws_vpc.myvpc.tags.Name
}

output "public_subnet_1" {
	value	  = values(aws_subnet.public_subnets)[1].id
} 