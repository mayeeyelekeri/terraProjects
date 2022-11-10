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

output "public-subnets" {
	value	  = values(aws_subnet.private-subnets)[*].tags_all.Name
} 

output "public-subnet-names" {
	value	  = keys(aws_subnet.public-subnets)[*]
} 

/* output "PUBLIC-SUBNET2-NAME" {
  description = "Private Subnet"
  value       = aws_subnet.mysubnet2.tags.Name
} 

output "PUBLIC-SUBNET3-NAME" {
  description = "Private Subnet"
  value       = aws_subnet.mysubnet3.tags.Name
}  */ 
