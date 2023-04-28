/* -------- Create Public Key -------------
 Inputs: 
 1) Location of local public key 
 2) key name  
 Outputs: 
 1) key-pair 
----------------------------------------------------------- */ 
resource "aws_key_pair" "mykeypair" {
    key_name    = var.key_name
    public_key  = file("~/.ssh/id_rsa.pub")
}

/* --------------------------------------------------------
Create Template for user-data (for installing docker and codedeploy agent)-------------
 Inputs: 
 1) template file name 
 2) application name 
 Outputs: 
 1) user_data, basically a text formatted string 
----------------------------------------------------------- */ 
data "template_file" "user_data" {
  template = "${file("install_docker_and_agent.tpl")}"
  vars = {
    application = "docker"
  }
}

# ****** This is sunsetted by AWS itself, using launch template instead 
# Create Launch configuration (This one is common for both client and server)
/*resource "aws_launch_configuration" "al_conf" {
  name_prefix          = "${terraform.workspace}_"
  image_id             = var.ami_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  security_groups      = [var.public_sg_id] 
  user_data            = "${data.template_file.user_data.rendered}"
  iam_instance_profile = var.instance_profile_name 

  lifecycle {
    create_before_destroy = true
  }

  #depends_on = [aws_iam_instance_profile.myinstanceprofile , aws_lb_listener.listener]
} */
 
/* --------------------------------------------------------
Create Launch template (This one is common for both client and server)
 Inputs: 
 1) template name  
 2) ami_id 
 3) instance type 
 4) key_name 
 5) private security group ID  
 6) user data 
 7) instance profile name 
----------------------------------------------------------- */ 
resource "aws_launch_template" "docker_template_server" {
  name                    = var.template_name_server
  image_id                = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key_name
  vpc_security_group_ids  = [var.private_sg_id] 
  user_data               = "${base64encode(data.template_file.user_data.rendered)}"
  iam_instance_profile  {
        name =  var.instance_profile_name 
  }

  lifecycle {
    create_before_destroy = true
  } 
}


/* ------- Create Auto Scaling group for info-server ------- 
 Inputs: 
 1) Application name  
 2) Launch template ID 
 3) Load Balancer ARN name 
 4) Private Subnet IDs 
 5) Health Check type   
 6) Min
 7) Max  
----------------------------------------------------------- */ 
resource "aws_autoscaling_group" "auto_scale_group" {
  name                 = "${var.app_name_server}-autoscale-group-server"
  launch_template  {
        id      = aws_launch_template.docker_template_server.id 
        version = "$Latest" 
  } 
  target_group_arns    = [var.alb_tg_server_arn]

  # Pickup all the private subnets 
  vpc_zone_identifier  = var.public_subnets[*].id
  health_check_type    = "EC2" 
  min_size             = var.autoscale_min
  max_size             = var.autoscale_max
  
  tag {
    key                 = "Name"
    value               = "${terraform.workspace}_${var.app_name_server}"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_template.docker_template_server]
}