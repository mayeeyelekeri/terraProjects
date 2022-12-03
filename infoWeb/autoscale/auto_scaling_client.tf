/* --------- Create Auto Scaling group for info-client  -----
 Inputs: 
 1) Application name  
 2) Launch template ID 
 3) Load Balancer ARN name 
 4) Private Subnet IDs 
 5) Health Check type   
 6) Min
 7) Max  
----------------------------------------------------------- */ 
resource "aws_autoscaling_group" "auto_scale_group_client" {
  name                 = var.app_name_client
  launch_template  {
        id      = aws_launch_template.docker_template.id 
        version = "$Latest" 
  } 
  target_group_arns    = [var.alb_tg_client_arn]

  # Pickup all the private subnets 
  vpc_zone_identifier  = var.public_subnets[*].id
  health_check_type    = "EC2" 
  min_size             = var.autoscale_min
  max_size             = var.autoscale_max

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}_${var.app_name_client}"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_template.docker_template]
}