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
    provisioner "local-exec" {
    command = <<EOF
cd ${var.info_server_workspace}; mvn clean package
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

resource "aws_launch_configuration" "al_conf" {
  image_id        = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.public_sg.id] 
  user_data       = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "sc_group" {
  name                 = "my_asg"
  launch_configuration = aws_launch_configuration.al_conf.name
  # availability_zones   = ["us-east-1a" , "us-east-1b"]
  vpc_zone_identifier       = [values(aws_subnet.public_subnets)[0].id, values(aws_subnet.public_subnets)[1].id]
  min_size             = 2
  max_size             = 3
}


# Create EC2 from docker image and copy software
resource "aws_instance" "info_server" {
  ami                         = var.docker_image_id
  instance_type               = var.instance_type
  
  ### instance profile is not required for this server 
  #iam_instance_profile        = aws_iam_instance_profile.myinstanceprofile.name
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.public_sg.id] 
  subnet_id                   = values(aws_subnet.public_subnets)[0].id

  # Install java and copy info-server war file 
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.id} && \
ansible-playbook --extra-vars "passed_in_hosts=${self.public_ip} \
war_file=${var.war_file} docker_file=${var.docker_file} image_name=${var.image_name}" \
ansible_templates/copy_and_start_docker.yaml
EOF
  } # End of provisioner

  tags = {
    Name = join("-", ["${terraform.workspace}", "infoserver" ])
    Environment = "${terraform.workspace}"
  }

  depends_on = [null_resource.create_package]
}


/* # Install docker and install Info-Server 
resource "aws_instance" "info_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  
  ### instance profile is not required for this server 
  #iam_instance_profile        = aws_iam_instance_profile.myinstanceprofile.name
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.public_sg.id] 
  subnet_id                   = values(aws_subnet.public_subnets)[0].id

  # Install java and copy info-server war file 
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.id} && \
ansible-playbook --extra-vars "passed_in_hosts=${self.public_ip} \
war_file=${var.war_file} docker_file=${var.docker_file} image_name=${var.image_name}" \
ansible_templates/install_docker.yaml
EOF
  } # End of provisioner

  tags = {
    Name = join("-", ["${terraform.workspace}", "infoserver" ])
    Environment = "${terraform.workspace}"
  }

  depends_on = [null_resource.create_package]
} */ 

