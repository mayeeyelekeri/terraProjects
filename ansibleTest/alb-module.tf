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

# Create Jenkins server on any subnet 
resource "aws_instance" "jenkins-server" {
  ami                         = var.ami-id
  instance_type               = var.instance-type
  associate_public_ip_address = true
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.public-sg.id] 
  subnet_id                   = values(aws_subnet.public-subnets)[0].id  # get the first subnet id 
  
  provisioner "remote-exec" {
    inline = ["sudo yum update -y", "sudo yum install python3 -y", "echo Done!"]

    connection {
      host        = self.public_ip
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("~/.ssh/id_rsa")
    }
  }

  provisioner "local-exec" {
    command = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.id} && ansible-playbook --extra-vars 'ANSIBLE_HOST_KEY_CHECKING=False  passed_in_hosts=${self.public_ip}' ansible_templates/install_jenkins.yaml
EOF
  }
  tags = {
    # Name = join("-", ["${terraform.workspace}", "Jenkins-server" ])
    Name = "jenkinsserver"
    Environment = "${terraform.workspace}"
  }
}

/* # Create EC2 web servers in different subnets 
resource "aws_instance" "webservers" {
  for_each                    = aws_subnet.public-subnets
  ami                         = var.ami-id
  instance_type               = var.instance-type
  associate_public_ip_address = true
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.public-sg.id] 
  subnet_id                   = each.value.id
  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd && sudo systemctl start httpd",
      "echo '<html><body><h1><center> My public IP address is : </center></h1>' > index.html", 
      "echo '<h2  style=\"background-color:' >> index.html",
      "echo ${var.ec2-data[each.key].color} >> index.html", 
      "echo ';\"><center> ' >> index.html",
      "curl http://169.254.169.254/latest/meta-data/public-ipv4 >> index.html",
      "echo '</h2></center> </body> </html>' >> index.html",
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
    Name = join("-", ["${terraform.workspace}", "webserver" ])
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
resource "aws_lb_target_group_attachment" "attach_ec2" {
    for_each = aws_instance.webservers 
    target_group_arn = aws_lb_target_group.tg.arn
    target_id = each.value.id 
    port = 80 
}

# -------- END: Template code to get all subnets in a VPC - END --------- 

# -------- Create application load balancer -------------
resource "aws_lb" "alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public-sg.id]
  subnets            = tolist(values(aws_subnet.public-subnets)[*].id)
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
} */ 