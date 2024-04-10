/* -------- Create application load balancer -------------
 Inputs: 
 1) security group from VPC module 
 2) Private subnet IDs from VPC module 
 Outputs: 
 1) arn name  (used in "Listener") 
 2) dns_name is exported outside the module 
----------------------------------------------------------- */ 
resource "aws_lb" "alb" {
  name               = "ALB-Public"
  internal           = false
  load_balancer_type = "application"

  security_groups    = [var.public_sg_id]
  subnets            = [var.public_subnets[0].id, var.public_subnets[1].id]
  enable_deletion_protection = false

  tags = {
    Name = "${terraform.workspace}-alb-Public"
    Environment = "${terraform.workspace}"
  }
}

/* ------------- Create ALB Target Group -------------------
Inputs: 
 1) VPC ID from VPC module 
 2) Port where application is running 
 3) Path for health check 
Outputs: 
 1) arn name  (used in "Listener") 
-----------------------------------------------------------*/ 
resource "aws_lb_target_group" "tg" {
  name  = "${terraform.workspace}-tg"
  protocol = "HTTP"

  # The port where application is running on EC2 
  port     = var.application_port

  vpc_id   = var.vpc_id
  
  health_check { 
    enabled = true 
    healthy_threshold = 3 
    interval = 10 
    matcher = 200
    path = var.app_health_check_path

    timeout = 3
    unhealthy_threshold = 2
  }
  tags = {
    Name = "${terraform.workspace}-tg"
    Environment = "${terraform.workspace}"
  }
}

/* ------- Create a Listener and attach it to ALB ----------
Inputs: 
 1) Load Balancer arn name 
 2) target group arn name 
Outputs: 
 1) arn name exported outside the module 
-----------------------------------------------------------*/
resource "aws_lb_listener" "listener" {
    protocol = "HTTP"

    # Port where Application Load balancer is listening at 
    port = "80"
    
    load_balancer_arn = aws_lb.alb.arn 
    
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