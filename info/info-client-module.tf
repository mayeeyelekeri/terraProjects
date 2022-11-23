# Get database endpoint and update infoserver application-aws.properties 
resource "null_resource" "update_server_ipaddress" {
    provisioner "local-exec" {
    command = <<EOF
ansible-playbook --extra-vars "passed_in_hosts=localhost \
info_server_ipaddress=${aws_instance.info-server.ipaddress} \
info_server_port=${var.info_server_port}"
ansible_templates/replace_application_properties.yaml
EOF
  } # End of provisioner

    depends_on = [aws_db_instance.infodb, aws_instance.info-server]
}

# Perform compilation of server 
resource "null-resource" "create_client_package" {
    provisioner "local-exec" {
    command = <<EOF
cd ${var.info_server_workspace}; mvn clean package
EOF
  } # End of provisioner

    depends_on = [null_resource.update_server_ipaddress]
} 

# Install docker and install Info-Client 
resource "aws_instance" "info-client" {
  ami                         = var.ami-id
  instance_type               = var.instance-type
  iam_instance_profile        = aws_iam_instance_profile.myinstanceprofile.name
  associate_public_ip_address = true
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.public-sg.id] 
  subnet_id                   = values(aws_subnet.public-subnets)[0].id

  # Install java and copy springboot war file 
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.id} && \
ansible-playbook --extra-vars "passed_in_hosts=${self.public_ip} \
war_file=${var.war-file-client} docker_file=${var.docker-file-client} image_name=${var.image-name-client}" \
ansible_templates/install_docker.yaml
EOF
  } # End of provisioner

  tags = {
    Name = join("-", ["${terraform.workspace}", "clientserver" ])
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_iam_role.myec2role , aws_iam_role_policy_attachment.roll_attach_to_policy , aws_db_instance.infodb , aws_instance.info-server, null_resource.create_client_package]
}   

