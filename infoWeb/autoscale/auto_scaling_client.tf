# Create Auto Scaling group 
resource "aws_autoscaling_group" "auto_scale_group_client" {
  name                 = var.app_name_client
  launch_configuration = aws_launch_configuration.al_conf.name
  target_group_arns    = [var.alb_tg_client_arn]
  vpc_zone_identifier  = [var.public_subnets[0].id, var.public_subnets[1].id]
  health_check_type    = "EC2" 
  min_size             = 2
  max_size             = 3

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}_${var.app_name_client}"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_configuration.al_conf]
}