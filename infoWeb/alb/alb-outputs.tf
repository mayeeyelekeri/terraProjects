output "alb_server_dns" {
  value       = aws_lb.alb_client.dns_name
}

output "alb_client_dns" {
  value       = aws_lb.alb_server.dns_name
}

output "alb_tg_server_arn" {
  value       = aws_lb_target_group.tg_server.arn
}

output "alb_tg_client_arn" {
  value       = aws_lb_target_group.tg_client.arn
}