# Install docker and install Info-Server 
resource "aws_instance" "info-server" {
  ami                         = var.ami-id
  instance_type               = var.instance-type
  iam_instance_profile        = aws_iam_instance_profile.myinstanceprofile.name
  associate_public_ip_address = true
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.public-sg.id] 
  subnet_id                   = values(aws_subnet.public-subnets)[1].id

  # Install java and copy springboot war file 
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.id} && \
ansible-playbook --extra-vars "passed_in_hosts=${self.public_ip} \
war_file=${var.war-file} docker_file=${var.docker-file} image_name=${var.image-name}" \
ansible_templates/install_docker.yaml
EOF
  } # End of provisioner

  tags = {
    Name = join("-", ["${terraform.workspace}", "httpserver" ])
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_iam_role.myec2role , aws_iam_role_policy_attachment.roll_attach_to_policy ]
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

  depends_on = [aws_iam_role.myec2role , aws_iam_role_policy_attachment.roll_attach_to_policy ]
}   

