output "docker_ami_id" {
	value = aws_ami_from_instance.myami.id
} 