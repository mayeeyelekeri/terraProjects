# Create EC2 web servers in different subnets 
resource "aws_instance" "private-webservers" {
  for_each                    = aws_subnet.private-subnets
  ami                         = var.myimage
  instance_type               = var.instance-type
  associate_public_ip_address = false
  key_name                    = var.key-name
  vpc_security_group_ids      = [aws_security_group.private-sg.id]
  subnet_id                   = each.value.id
  
  tags = {
    Name = join("-", ["${terraform.workspace}", "webserver", each.value.id])
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_key_pair.mykeypair]
}


# ------------- Create ALB Target Group ----------
resource "aws_lb_target_group" "tg-private" {
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

# -------- Attach all private EC2 webserver instances to Target group 2 ----------------
resource "aws_lb_target_group_attachment" "attach_ec2-private" {
    for_each = aws_instance.private-webservers 
    target_group_arn = aws_lb_target_group.tg-private.arn
    target_id = each.value.id 
    port = 80 
}

# -------- Create application load balancer for private ec2s -------------
resource "aws_lb" "alb-private" {
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public-sg.id]
  subnets            = tolist(values(aws_subnet.private-subnets)[*].id)
  enable_deletion_protection = false

  tags = {
    Name = "${terraform.workspace}-albTargetGroup-private"
    Environment = "${terraform.workspace}"
  }
}

# ------- Create a Listener and attach it to ALB -----------------------
resource "aws_lb_listener" "listener-private" {
    load_balancer_arn = aws_lb.alb-private.arn 
    port = "80"
    protocol = "HTTP"

    default_action { 
        type = "forward"
        target_group_arn = aws_lb_target_group.tg-private.arn
    }
}


