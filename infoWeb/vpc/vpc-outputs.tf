output "vpc_id" {
  description = "VPC ID created"
  value       = aws_vpc.myvpc.id
}

output "vpc_name" {
  description = "VPC ID created"
  value       = aws_vpc.myvpc.tags.Name
}

output "public_subnets" {
	value	  = values(aws_subnet.public_subnets)
} 

output "public_sg" {
	value = "aws_security_group.public_sg.id"
}