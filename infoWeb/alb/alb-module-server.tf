# ------------- Create ALB Target Group ----------
resource "aws_lb_target_group" "tg" {
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id
  health_check { 
    enabled = true 
    healthy_threshold = 3 
    interval = 10 
    matcher = 200
    path = "/infos"

    timeout = 3
    unhealthy_threshold = 2
  }
  tags = {
    Name = "${terraform.workspace}-albTargetGroup"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_vpc.myvpc]
}

# -------- Create application load balancer -------------
resource "aws_lb" "alb" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = [values(aws_subnet.public_subnets)[0].id, values(aws_subnet.public_subnets)[1].id]
  enable_deletion_protection = false

  tags = {
    Name = "${terraform.workspace}-albTargetGroup"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_lb_target_group.tg, aws_security_group.public_sg, aws_subnet.public_subnets]

}

# ------- Create a Listener and attach it to ALB -----------------------
resource "aws_lb_listener" "listener" {
    load_balancer_arn = aws_lb.alb.arn 
    port = "8080"
    protocol = "HTTP"

    default_action { 
        type = "forward"
        target_group_arn = aws_lb_target_group.tg.arn
    }

    tags = {
      Name = "${terraform.workspace}-listener"
      Environment = "${terraform.workspace}"
    }

    depends_on = [aws_lb.alb , aws_lb_target_group.tg]
}