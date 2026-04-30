# ------------------------------------------------------------------------------
# Auto Scaling group for the application tier
# ------------------------------------------------------------------------------

resource "aws_autoscaling_group" "webapp" {
  name = "ha-webapp-asg"

  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  vpc_zone_identifier = [
    aws_subnet.private_app_a.id,
    aws_subnet.private_app_b.id,
  ]

  target_group_arns         = [aws_lb_target_group.webapp.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.webapp.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ha-webapp-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ------------------------------------------------------------------------------
# Target tracking scaling policy
# ------------------------------------------------------------------------------

resource "aws_autoscaling_policy" "webapp_cpu" {
  name                   = "ha-webapp-cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.webapp.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60
  }
}
