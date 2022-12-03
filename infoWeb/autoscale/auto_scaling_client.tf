/* --------------------------------------------------------
Create Launch template (This one is common client only, needs to have public access)
 Inputs: 
 1) template name  
 2) ami_id 
 3) instance type 
 4) key_name 
 5) private security group ID  
 6) user data 
 7) instance profile name 
----------------------------------------------------------- */ 
resource "aws_launch_template" "docker_template_client" {
  name                    = var.template_name
  image_id                = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key_name
  vpc_security_group_ids  = [var.public_sg_id] 
  user_data               = "${base64encode(data.template_file.user_data.rendered)}"
  iam_instance_profile  {
        name =  var.instance_profile_name 
  }

  lifecycle {
    create_before_destroy = true
  } 
}

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
        id      = aws_launch_template.docker_template_client.id 
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

  depends_on = [aws_launch_template.docker_template_client]
}