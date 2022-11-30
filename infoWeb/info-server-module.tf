####  database ID/pasword coming from AWS Secrets Manager 
####  "mysql_user" and "mysql_password"
# Get db secrets from AWS Secret Manager 
data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = var.mysql_creds 
}

locals {mysql_creds = jsondecode(data.aws_secretsmanager_secret_version.creds.secret_string)}


# Get database endpoint and update infoserver application-aws.properties 
resource "null_resource" "update_database_endpoint" {
  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }

    provisioner "local-exec" {
    command = <<EOF
ansible-playbook --extra-vars "passed_in_hosts=localhost mysql_host=${local.mysql_creds.mysql_endpoint} \
mysql_port=${local.mysql_creds.mysql_port} \
mysql_user=${local.mysql_creds.mysql_user} \
mysql_password=${local.mysql_creds.mysql_password} \
mysql_database=${local.mysql_creds.mysql_database} \
src_file=${var.src_properties_file} \
dest_file=${var.dest_properties_file}" \
ansible_templates/replace_application_properties.yaml
EOF
  } # End of provisioner
}

# Perform compilation of server 
resource "null_resource" "create_package" {

  # This timestamps makes this resource to run all time, even if there is no change
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOF
cd ${var.info_server_workspace}; mvn clean package; cp target/${var.jar_file} ${var.webapp_src_location}
EOF
  } # End of provisioner

    depends_on = [null_resource.update_database_endpoint]
}


data "template_file" "user_data" {
  template = "${file("install_app.tpl")}"
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
  security_groups      = [aws_security_group.public_sg.id] 
  user_data            = "${data.template_file.user_data.rendered}"
  iam_instance_profile = "myinstanceprofile" 

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_security_group.public_sg, aws_iam_instance_profile.myinstanceprofile , aws_lb_listener.listener]
}

# Create Auto Scaling group 
resource "aws_autoscaling_group" "auto_scale_group" {
  name                 = "my_asg"
  launch_configuration = aws_launch_configuration.al_conf.name
  #load_balancers      = [aws_lb.alb.id]
  target_group_arns    = [aws_lb_target_group.tg.arn]
  vpc_zone_identifier  = [values(aws_subnet.public_subnets)[0].id, values(aws_subnet.public_subnets)[1].id]
  health_check_type    = "EC2" 
  min_size             = 2
  max_size             = 3


  depends_on = [aws_launch_configuration.al_conf]
}