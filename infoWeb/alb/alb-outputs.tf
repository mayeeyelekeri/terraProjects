output "alb_server" {
  value       = aws_lb.alb_client.id
}

output "alb_client" {
  value       = aws_lb.alb_server.id
}