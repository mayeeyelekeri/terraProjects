# Install docker and install Info-Client 
resource "aws_instance" "info_client_from_image" {
  ami                         = var.client_image
  instance_type               = var.instance_type
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
ansible_templates/copy_and_start_docker.yaml
EOF
  } # End of provisioner
  
  tags = {
    Name = join("-", ["${terraform.workspace}", "client_from_image" ])
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_instance.info_server, null_resource.create_client_package]
} 


# Install docker and install Info-Client_template 
resource "aws_instance" "info_client_from_template" {
  #ami                         = var.client_image
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [aws_security_group.public_sg.id] 
  subnet_id                   = values(aws_subnet.public_subnets)[1].id

  launch_template = {
    id      = "lt-0a21964d054da109b"
    version = "1"
  }

  # Install java and copy info-client war file 
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.id} && \
ansible-playbook --extra-vars "passed_in_hosts=${self.public_ip} \
war_file=${var.war_file_client} docker_file=${var.docker_file_client} image_name=${var.image_name_client}" \
ansible_templates/copy_and_start_docker.yaml
EOF
  } # End of provisioner
  
  tags = {
    Name = join("-", ["${terraform.workspace}", "client_from_image" ])
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_instance.info_server, null_resource.create_client_package]
} 