output "server_load_balancer" {
	value = module.alb.alb_server
}

output "client_load_balancer" {
	value = module.alb.alb_server.client
}

