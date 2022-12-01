# ------------- Create ALB Target Group ----------
resource "aws_lb_target_group" "tg" {
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
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

  #depends_on = [aws_vpc.myvpc]
}

# -------- Create application load balancer -------------
resource "aws_lb" "alb_server" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg]
  subnets            = [(var.public_subnets)[0].id, (var.public_subnets)[1].id]
  enable_deletion_protection = false

  tags = {
    Name = "${terraform.workspace}-albTargetGroup"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_lb_target_group.tg]

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

    depends_on = [aws_lb.alb_server , aws_lb_target_group.tg]
}