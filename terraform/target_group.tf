# ------------------------------------------------------------------------------
# Application load balancer target group
# ------------------------------------------------------------------------------

resource "aws_lb_target_group" "webapp" {
  name        = "webapp-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.webapp_vpc.id

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }

  tags = {
    Name = "webapp-tg"
  }
}
