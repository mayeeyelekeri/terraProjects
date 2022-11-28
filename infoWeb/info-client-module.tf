/* # Get database endpoint and update infoserver application-aws.properties 
resource "null_resource" "update_server_dns" {
    provisioner "local-exec" {
    command = <<EOF
ansible-playbook --extra-vars "passed_in_hosts=localhost \
info_server_ipaddress=${aws_instance.info_server.public_ip} \
info_server_port=${var.info_server_port} \
src_file=${var.src_properties_file_client} \
dest_file=${var.dest_properties_file_client}" \
ansible_templates/replace_application_properties.yaml
EOF
  } # End of provisioner

    depends_on = [aws_instance.info_server]
}

# Perform compilation of server 
resource "null_resource" "create_client_package" {
    provisioner "local-exec" {
    command = <<EOF
cd ${var.info_client_workspace}; mvn clean package
EOF
  } # End of provisioner

    depends_on = [null_resource.update_server_dns]
} 

# Install docker and install Info-Client 
resource "aws_instance" "info_client" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  #iam_instance_profile        = aws_iam_instance_profile.myinstanceprofile.name
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.public_sg.id] 
  subnet_id                   = values(aws_subnet.public_subnets)[1].id

  # Install java and copy info-client war file 
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.id} && \
ansible-playbook --extra-vars "passed_in_hosts=${self.public_ip} \
war_file=${var.war_file_client} docker_file=${var.docker_file_client} image_name=${var.image_name_client}" \
ansible_templates/install_docker.yaml
EOF
  } # End of provisioner

  tags = {
    Name = join("-", ["${terraform.workspace}", "client" ])
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_instance.info_server, null_resource.create_client_package]
} 

*/ 