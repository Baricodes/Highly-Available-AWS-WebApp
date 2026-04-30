# ------------------------------------------------------------------------------
# Auto Scaling group CPU alarm
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "asg_cpu_high" {
  alarm_name          = "ha-webapp-asg-cpu-high"
  alarm_description   = "Average CPU utilization for the web app Auto Scaling group is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.asg_cpu_high_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = var.cloudwatch_alarm_actions
  ok_actions          = var.cloudwatch_alarm_actions

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp.name
  }

  tags = {
    Name = "ha-webapp-asg-cpu-high"
  }
}

# ------------------------------------------------------------------------------
# Application load balancer target health alarm
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "ha-webapp-alb-unhealthy-hosts"
  alarm_description   = "One or more targets behind the web app ALB are unhealthy"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Maximum"
  threshold           = 0
  treat_missing_data  = "notBreaching"
  alarm_actions       = var.cloudwatch_alarm_actions
  ok_actions          = var.cloudwatch_alarm_actions

  dimensions = {
    LoadBalancer = aws_lb.webapp.arn_suffix
    TargetGroup  = aws_lb_target_group.webapp.arn_suffix
  }

  tags = {
    Name = "ha-webapp-alb-unhealthy-hosts"
  }
}

# ------------------------------------------------------------------------------
# RDS alarms
# ------------------------------------------------------------------------------

resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "ha-webapp-rds-cpu-high"
  alarm_description   = "CPU utilization for the web app RDS instance is high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.rds_cpu_high_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = var.cloudwatch_alarm_actions
  ok_actions          = var.cloudwatch_alarm_actions

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.webapp.identifier
  }

  tags = {
    Name = "ha-webapp-rds-cpu-high"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_free_storage_low" {
  alarm_name          = "ha-webapp-rds-free-storage-low"
  alarm_description   = "Free storage space for the web app RDS instance is low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.rds_free_storage_low_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = var.cloudwatch_alarm_actions
  ok_actions          = var.cloudwatch_alarm_actions

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.webapp.identifier
  }

  tags = {
    Name = "ha-webapp-rds-free-storage-low"
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_database_connections_high" {
  alarm_name          = "ha-webapp-rds-database-connections-high"
  alarm_description   = "Database connections for the web app RDS instance are high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.rds_database_connections_high_threshold
  treat_missing_data  = "notBreaching"
  alarm_actions       = var.cloudwatch_alarm_actions
  ok_actions          = var.cloudwatch_alarm_actions

  dimensions = {
    DBInstanceIdentifier = aws_db_instance.webapp.identifier
  }

  tags = {
    Name = "ha-webapp-rds-database-connections-high"
  }
}
