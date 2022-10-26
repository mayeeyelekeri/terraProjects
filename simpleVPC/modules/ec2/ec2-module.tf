
# Reference VPC module 
module "vpc-module" {
    source = "../vpc"
}


# Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "webserver-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Create key-pair for logging into EC2 
resource "aws_key_pair" "webserver-key" {
  key_name   = "webserver-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create EC2 web server
resource "aws_instance" "webserver" {
  ami                         = "ami-09d3b3274b6c5d4aa"
  instance_type               = var.instance-type
  associate_public_ip_address = true
  key_name                    = aws_key_pair.webserver-key.key_name
  vpc_security_group_ids      = [module.vpc-module.PUBLIC-SECURIY-GROUP] # these values are exported from vpc-outputs.tf 
  subnet_id                   = module.vpc-module.PUBLIC-SUBNET-ID
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1><center>My Website via Terraform Version 1</center></h1>' > index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
  tags = {
    Name = "webserver"
  }
}