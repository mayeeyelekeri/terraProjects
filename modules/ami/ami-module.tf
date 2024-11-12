# Create and EC2 and create AMI from it 

/* --------------------------------------------------------
Create Template for user-data (for installing docker and codedeploy agent)-------------
 Inputs: 
 1) template file name 
 2) application name 
 Outputs: 
 1) user_data, basically a text formatted string 
----------------------------------------------------------- */ 
data "template_file" "user_data" {
  template = "${file("install_docker_and_agent.tpl")}"
  vars = {
    application = "docker"
  }
}

# create an EC2 first 
resource "aws_instance" "ami-server" {
  	ami                         = var.ami_id
  	instance_type               = var.instance_type
  	associate_public_ip_address = true
  	key_name                    = var.key_name
  	vpc_security_group_ids      = [var.public_sg_id] 
  	subnet_id                   = var.public_subnets[0].id
  	
  	user_data               = "${base64encode(data.template_file.user_data.rendered)}"
  	
  	iam_instance_profile = var.instance_profile_name 
  	
  	tags = {
    	Name = "${terraform.workspace}-template"
    	Environment = "${terraform.workspace}"
  	}

  	# depends_on = [aws_key_pair.mykeypair]
} 

# Create AMI from the instance 
resource "aws_ami_from_instance" "myami" {
  name               = "terraform-example"
  source_instance_id = aws_instance.ami-server.id
}


