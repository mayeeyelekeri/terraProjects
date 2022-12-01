output "auto_scale_group_name_server" {
  value       = aws_autoscaling_group.auto_scale_group.name
} 

output "auto_scale_group_name_client" {
  value       = aws_autoscaling_group.auto_scale_group_client.name
} 