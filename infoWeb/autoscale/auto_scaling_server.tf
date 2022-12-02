data "template_file" "user_data" {
  template = "${file("install_docker_and_agent.tpl")}"
  vars = {
    application = "docker"
  }
}

# Import public key to aws 
resource "aws_key_pair" "mykeypair" {
    key_name    = var.key_name
    public_key  = file("~/.ssh/id_rsa.pub")
}

# Get Linux AMI ID 
data "aws_ssm_parameter" "linux-ami" {
    name        = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# ****** This is sunsetted by AWS itself, using launch template instead 
# Create Launch configuration (This one is common for both client and server)
resource "aws_launch_configuration" "al_conf" {
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
}
 
# Create Launch template (This one is common for both client and server)
resource "aws_launch_template" "docker_template" {
  name                    = "docker_and_codedeploy_agent"
  #name_prefix             = "${terraform.workspace}_"
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

# Create Auto Scaling group 
resource "aws_autoscaling_group" "auto_scale_group" {
  name                 = var.app_name_server
  launch_template  {
        id      = aws_launch_template.docker_template.id 
        version = '$Latest' 
  } 
  target_group_arns    = [var.alb_tg_server_arn]
  vpc_zone_identifier  = [var.public_subnets[0].id, var.public_subnets[1].id]
  health_check_type    = "EC2" 
  min_size             = var.autoscale_min
  max_size             = var.autoscale_max
  
  tag {
    key                 = "Name"
    value               = "${terraform.workspace}_${var.app_name_server}"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_configuration.al_conf]
}