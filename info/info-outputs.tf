output "database_endpoint" {
	value = aws_db_instance.infodb.address
}

output "info-server-ipaddress" {
	value = aws_instance.info_server.public_ip
}

output "info-client-ipaddress" {
	value = aws_instance.info_client.public_ip
}
