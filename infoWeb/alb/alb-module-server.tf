# ------------- Create ALB Target Group ----------
resource "aws_lb_target_group" "tg_server" {
  port     = 80
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
    Name = "${terraform.workspace}-tg-server"
    Environment = "${terraform.workspace}"
  }
}

# -------- Create application load balancer -------------
resource "aws_lb" "alb_server" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg_id]
  subnets            = [var.public_subnets[0].id, var.public_subnets[1].id]
  enable_deletion_protection = false

  tags = {
    Name = "${terraform.workspace}-alb-server"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_lb_target_group.tg_server]

}

# ------- Create a Listener and attach it to ALB -----------------------
resource "aws_lb_listener" "listener_server" {
    load_balancer_arn = aws_lb.alb_server.arn 
    port = "8080"
    protocol = "HTTP"

    default_action { 
        type = "forward"
        target_group_arn = aws_lb_target_group.tg_server.arn
    }

    tags = {
      Name = "${terraform.workspace}-listener-server"
      Environment = "${terraform.workspace}"
    }

    depends_on = [aws_lb.alb_server , aws_lb_target_group.tg_server]
}