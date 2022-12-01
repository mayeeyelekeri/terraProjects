output "alb_server" {
  value       = aws_lb.alb_client.dns_name
}

output "alb_client" {
  value       = aws_lb.alb_server.dns_name
}