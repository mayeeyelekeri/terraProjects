output "ec2-ip-address" { 
	value = aws_instance.webserver.public_ip
}

output "vpc1-id" { 
	value = aws_vpc.vpc.id 
}

output "secret-value" { 
	value = "some-secret" 
	sensitive = false
}
