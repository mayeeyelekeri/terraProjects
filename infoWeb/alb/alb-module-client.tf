# ------------- Create ALB Target Group for Client ----------
resource "aws_lb_target_group" "tg_client" {
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
    Name = "${terraform.workspace}-albTargetGroup-client"
    Environment = "${terraform.workspace}"
  }

  #depends_on = [aws_vpc.myvpc]
}

# -------- Create application load balancer -------------
resource "aws_lb" "alb_client" {
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg]
  subnets            = [values(public_subnets)[0].id, values(public_subnets)[1].id]
  enable_deletion_protection = false

  tags = {
    Name = "${terraform.workspace}-alb-client"
    Environment = "${terraform.workspace}"
  }

  depends_on = [aws_lb_target_group.tg_client, aws_security_group.public_sg, aws_subnet.public_subnets]

}

# ------- Create a Listener and attach it to ALB -----------------------
resource "aws_lb_listener" "listener_client" {
    load_balancer_arn = aws_lb.alb_client.arn 
    port = "8080"
    protocol = "HTTP"

    default_action { 
        type = "forward"
        target_group_arn = aws_lb_target_group.tg_client.arn
    }

    tags = {
      Name = "${terraform.workspace}-listener-client"
      Environment = "${terraform.workspace}"
    }

    depends_on = [aws_lb.alb_client , aws_lb_target_group.tg_client]
}