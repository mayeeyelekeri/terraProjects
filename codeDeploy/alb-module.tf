# Import public key to aws 
resource "aws_key_pair" "mykeypair" {
    key_name    = var.key-name
    public_key  = file("~/.ssh/id_rsa.pub")
}

# Get Linux AMI ID 
data "aws_ssm_parameter" "linux-ami" {
    #provider    = "aws" 
    name        = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Create EC2 web servers in different subnets 
resource "aws_instance" "http-server" {
  for_each                    = aws_subnet.public-subnets
  ami                         = var.ami-id
  instance_type               = var.instance-type
  associate_public_ip_address = true
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.public-sg.id] 
  subnet_id                   = each.value.id
  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.id} && ansible-playbook --extra-vars 'passed_in_hosts=${self.public_ip}' ansible_templates/install_codedeploy_agent.yaml
EOF
  } # End of provisioner

  tags = {
    Name = join("-", ["${terraform.workspace}", "httpserver" ])
    Environment = "${terraform.workspace}"
  }
}   