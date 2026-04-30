# ------------------------------------------------------------------------------
# Application load balancer
# ------------------------------------------------------------------------------

resource "aws_lb" "webapp" {
  name               = "ha-webapp-alb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id,
  ]

  tags = {
    Name = "ha-webapp-alb"
  }
}

# ------------------------------------------------------------------------------
# HTTP listener
# ------------------------------------------------------------------------------

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.webapp.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp.arn
  }
}

# ------------------------------------------------------------------------------
# HTTPS listener
# ------------------------------------------------------------------------------

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.webapp.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = aws_acm_certificate_validation.webapp.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp.arn
  }
}

# ------------------------------------------------------------------------------
# ALB endpoint
# ------------------------------------------------------------------------------

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.webapp.dns_name
}

output "alb_https_url" {
  description = "HTTPS URL for the application load balancer"
  value       = "https://${var.app_domain_name}"
}
