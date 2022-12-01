data "template_file" "user_data" {
  template = "${file("install_docker_and_agent.tpl")}"
  vars = {
    application = "docker"
  }
}

# Create Launch configuration 
resource "aws_launch_configuration" "al_conf" {
  name_prefix          = "${terraform.workspace}_"
  image_id             = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  security_groups      = [var.public_sg] 
  user_data            = "${data.template_file.user_data.rendered}"
  iam_instance_profile = "myinstanceprofile" 

  lifecycle {
    create_before_destroy = true
  }

  #depends_on = [aws_iam_instance_profile.myinstanceprofile , aws_lb_listener.listener]
}

# Create Auto Scaling group 
resource "aws_autoscaling_group" "auto_scale_group" {
  name                 = var.app_name_server
  launch_configuration = aws_launch_configuration.al_conf.name
  target_group_arns    = [var.alb_tg_server_arn]
  vpc_zone_identifier  = [var.public_subnets[0].id, var.public_subnets[1].id]
  health_check_type    = "EC2" 
  min_size             = 2
  max_size             = 3

  tag {
    key                 = "Name"
    value               = "${terraform.workspace}_${var.app_name_server}"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_configuration.al_conf]
}