# Get db secrets from AWS Secret Manager 
data "aws_secretsmanager_secret_version" "creds" {
  # Fill in the name you gave to your secret
  secret_id = var.mysql_creds 
}

locals {
  mysql_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

# Get database endpoint and update infoserver application-aws.properties 
resource "null_resource" "update_database_endpoint" {
    provisioner "local-exec" {
    command = <<EOF
ansible-playbook --extra-vars "passed_in_hosts=localhost mysql_host=${var.infodb_endpoint} mysql_port=${var.mysql_port} mysql_user=${local.mysql_creds.mysql_user} mysql_password=${local.mysql_creds.mysql_password} mysql_database=${var.mysql_database} src_file=${var.src_properties_file} dest_file=${var.dest_properties_file}" ansible_templates/replace_application_properties.yaml
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

# Install docker and install Info-Server 
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
}

