output "server_load_balancer" {
	value = aws_lb.alb.dns_name
}

output "client_load_balancer" {
	value = aws_lb.alb_client.dns_name
}

