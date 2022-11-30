# Create Auto Scaling group 
resource "aws_autoscaling_group" "auto_scale_group_client" {
  name                 = "asg_client"
  launch_configuration = aws_launch_configuration.al_conf_client.name
  #load_balancers      = [aws_lb.alb_client.id]
  target_group_arns    = [aws_lb_target_group.tg_client.arn]
  vpc_zone_identifier  = [values(aws_subnet.public_subnets)[0].id, values(aws_subnet.public_subnets)[1].id]
  health_check_type    = "EC2" 
  min_size             = 2
  max_size             = 3

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}_${var.app_name_client}"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_configuration.al_conf_client]
}