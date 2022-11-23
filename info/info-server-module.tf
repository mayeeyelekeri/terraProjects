# Get database endpoint and update infoserver application-aws.properties 
resource "null_resource" "update_database_endpoint" {
    provisioner "local-exec" {
    command = <<EOF
ansible-playbook --extra-vars "passed_in_hosts=localhost \
mysql_host=${aws_db_instance.infodb.endpoint} \
mysql_port=${var.mysql_port} \
mysql_user=${var.mysql_user} \
mysql_password=${var.mysql_password} \
mysql_database=${var.mysql_database} \
src_file=${var.src_properties_file} \
dest_file=${var.dest_properties_file}"
ansible_templates/replace_application_properties.yaml
EOF
  } # End of provisioner

    depends_on = [aws_db_instance.infodb]
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
  iam_instance_profile        = aws_iam_instance_profile.myinstanceprofile.name
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.public_sg.id] 
  subnet_id                   = values(aws_subnet.public_subnets)[1].id

  # Install java and copy springboot war file 
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.id} && \
ansible-playbook --extra-vars "passed_in_hosts=${self.public_ip} \
war_file=${var.war_file} docker_file=${var.docker_file} image_name=${var.image_name}" \
ansible_templates/install_docker.yaml
EOF
  } # End of provisioner

  tags = {
    Name = join("-", ["${terraform.workspace}", "httpserver" ])
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_iam_role.myec2role , aws_iam_role_policy_attachment.roll_attach_to_policy , aws_db_instance.infodb]
} 

