
# Reference VPC module 
module "vpc-module" {
    source = "../vpc"
}

# Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "webserver-ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# Create EC2 web server in public subnet1 
resource "aws_instance" "webserver1" {
  ami                         = var.ami_id
  instance_type               = var.instance-type
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [module.vpc-module.PUBLIC-SECURITY-GROUP] # these values are exported from vpc-outputs.tf 
  subnet_id                   = module.vpc-module.PUBLIC-SUBNET1-ID
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1><center>My Website via Terraform on Oct 26 2022 </center></h1>' > index.html",
      "echo '<h2  style=\"background-color:Tomato;\"><center> Inside webserver 1 </center></h2>' >> index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.key_file_name)
      host        = self.public_ip
    }
  }
  tags = {
    Name = "${terraform.workspace}-webserver1"
    Environment = "${terraform.workspace}"
  }
} 

# Create EC2 web server in public subnet2 
resource "aws_instance" "webserver2" {
  ami                         = var.ami_id
  instance_type               = var.instance-type
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [module.vpc-module.PUBLIC-SECURITY-GROUP] # these values are exported from vpc-outputs.tf 
  subnet_id                   = module.vpc-module.PUBLIC-SUBNET2-ID
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1><center>My Website via Terraform on Oct 26 2022 </center></h1>' > index.html",
      "echo '<h2  style=\"background-color:Orange;\"><center> Inside webserver 2 </center></h2>' >> index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.key_file_name)
      host        = self.public_ip
    }
  }
  tags = {
    Name = "${terraform.workspace}-webserver2"
    Environment = "${terraform.workspace}"
  }
} 

# Create EC2 web server in public subnet3
resource "aws_instance" "webserver3" {
  ami                         = var.ami_id
  instance_type               = var.instance-type
  associate_public_ip_address = true
  key_name                    = var.key_name
  vpc_security_group_ids      = [module.vpc-module.PUBLIC-SECURITY-GROUP] # these values are exported from vpc-outputs.tf 
  subnet_id                   = module.vpc-module.PUBLIC-SUBNET3-ID
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<h1><center>My Website via Terraform on Oct 26 2022 </center></h1>' > index.html",
      "echo '<h2  style=\"background-color:Violet;\"><center> Inside webserver 3 </center></h2>' >> index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.key_file_name)
      host        = self.public_ip
    }
  }
  tags = {
    Name = "${terraform.workspace}-webserver3"
    Environment = "${terraform.workspace}"
  }
} 

# ------------- Create ALB Target Group ----------
resource "aws_lb_target_group" "tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc-module.VPC-ID
  health_check { 
    enabled = true 
    healthy_threshold = 3 
    interval = 10 
    matcher = 200
    path = "/"

    timeout = 3
    unhealthy_threshold = 2
  }
  tags = {
    Name = "${terraform.workspace}-albTargetGroup"
    Environment = "${terraform.workspace}"
  }
}

# -------- Attach all public EC2 webserver instances to Target group ----------------
resource "aws_lb_target_group_attachment" "attach_ec21" {
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = aws_instance.webserver1.id 
    port = 80 
}

resource "aws_lb_target_group_attachment" "attach_ec22" {
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = aws_instance.webserver2.id 
    port = 80 
}
resource "aws_lb_target_group_attachment" "attach_ec23" {
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = aws_instance.webserver3.id 
    port = 80 
}  

# -------- Create application load balancer -------------
resource "aws_lb" "alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.vpc-module.PUBLIC-SECURITY-GROUP]
  subnets            = [module.vpc-module.PUBLIC-SUBNET1-ID, module.vpc-module.PUBLIC-SUBNET2-ID, module.vpc-module.PUBLIC-SUBNET3-ID]

  enable_deletion_protection = true

  tags = {
    Name = "${terraform.workspace}-albTargetGroup"
    Environment = "${terraform.workspace}"
  }
}

# ------- Create a Listener and attach it to ALB -----------------------
resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.alb.arn 
    port = "80"
    protocol = "HTTP"

    default_action { 
        type = "forward"
        target_group_arn = aws_lb_target_group.tg.arn
    }
}
