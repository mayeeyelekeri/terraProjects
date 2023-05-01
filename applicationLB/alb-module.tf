# Create EC2 web servers in different subnets 
resource "aws_instance" "webserver1" {
  ami                         = var.ami-id
  instance_type               = var.instance-type
  associate_public_ip_address = true
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.public-sg.id] # these values are exported from vpc-outputs.tf 
  subnet_id                   = aws_subnet.mysubnet1.id
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<html><body><h1><center> My public IP address is : </center></h1>' > index.html", 
      "echo '<h2  style=\"background-color:Tomato;\"><center> ' >> index.html",
      "curl http://169.254.169.254/latest/meta-data/public-ipv4 >> index.html",
      "echo '</h2></center> </body> </html>' >> index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.key-file-name)
      host        = self.public_ip
    }
  }
  tags = {
    Name = join("-", ["${terraform.workspace}", "webserver", aws_subnet.mysubnet1.id])
    Environment = "${terraform.workspace}"
  }

  depends_on =  [aws_key_pair.mykeypair]
} 

resource "aws_instance" "webserver2" {
  ami                         = var.ami-id
  instance_type               = var.instance-type
  associate_public_ip_address = true
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.public-sg.id] # these values are exported from vpc-outputs.tf 
  subnet_id                   = aws_subnet.mysubnet2.id
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<html><body><h1><center> My public IP address is : </center></h1>' > index.html", 
      "echo '<h2  style=\"background-color:Red;\"><center> ' >> index.html",
      "curl http://169.254.169.254/latest/meta-data/public-ipv4 >> index.html",
      "echo '</h2></center> </body> </html>' >> index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.key-file-name)
      host        = self.public_ip
    }
  }
  tags = {
    Name = join("-", ["${terraform.workspace}", "webserver", aws_subnet.mysubnet2.id])
    Environment = "${terraform.workspace}"
  }
} 

resource "aws_instance" "webserver3" {
  ami                         = var.ami-id
  instance_type               = var.instance-type
  associate_public_ip_address = true
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.public-sg.id] # these values are exported from vpc-outputs.tf 
  subnet_id                   = aws_subnet.mysubnet3.id
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<html><body><h1><center> My public IP address is : </center></h1>' > index.html", 
      "echo '<h2  style=\"background-color:Yellow;\"><center> ' >> index.html",
      "curl http://169.254.169.254/latest/meta-data/public-ipv4 >> index.html",
      "echo '</h2></center> </body> </html>' >> index.html",
      "sudo mv index.html /var/www/html/"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.key-file-name)
      host        = self.public_ip
    }
  }
  tags = {
    Name = join("-", ["${terraform.workspace}", "webserver", aws_subnet.mysubnet3.id])
    Environment = "${terraform.workspace}"
  }
} 

# ------------- Create ALB Target Group ----------
resource "aws_lb_target_group" "tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id
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
resource "aws_lb_target_group_attachment" "attach_ec2-1" {
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = aws_instance.webserver1.id 
    port = 80 
}
resource "aws_lb_target_group_attachment" "attach_ec2-2" {
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = aws_instance.webserver2.id 
    port = 80 
}
resource "aws_lb_target_group_attachment" "attach_ec2-3" {
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = aws_instance.webserver3.id 
    port = 80 
}

# -------- BEGIN:  Template code to get all subnets in a VPC - BEGIN --------- 
/*data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.myvpc.id]
  }
}

data "aws_subnet" "example" {
  #for_each = toset(data.aws_subnets.example.ids)
  for_each = toset(data.aws_subnets.example.ids)
  id       = each.value
  
  
} */
# -------- END: Template code to get all subnets in a VPC - END --------- 

# -------- Create application load balancer -------------
resource "aws_lb" "alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public-sg.id]
  subnets            = [aws_subnet.mysubnet1.id, aws_subnet.mysubnet2.id, aws_subnet.mysubnet3.id]
  #subnets            =  aws_subnet.mysubnet.*
  enable_deletion_protection = false

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

/* -------- Create Public Key -------------
 Inputs: 
 1) Location of local public key 
 2) key name  
 Outputs: 
 1) key-pair 
----------------------------------------------------------- */ 
resource "aws_key_pair" "mykeypair" {
    key_name    = var.key_name
    public_key  = file("~/.ssh/id_rsa.pub")
}