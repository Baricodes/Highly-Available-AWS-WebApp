# ------------------------------------------------------------------------------
# RDS credentials (set via environment TF_VAR_* or a .tfvars file — do not commit secrets)
# ------------------------------------------------------------------------------

variable "db_master_username" {
  description = "Master username for the RDS MySQL instance"
  type        = string
}

variable "db_master_password" {
  description = "Master password for the RDS MySQL instance"
  type        = string
  sensitive   = true
}

# ------------------------------------------------------------------------------
# Public application DNS
# ------------------------------------------------------------------------------

variable "app_domain_name" {
  description = "Fully qualified domain name for the web app, for example app.example.com"
  type        = string
}

variable "route53_zone_id" {
  description = "Route 53 hosted zone ID that manages app_domain_name"
  type        = string
}

# ------------------------------------------------------------------------------
# S3 asset/log storage
# ------------------------------------------------------------------------------

variable "s3_assets_bucket_name" {
  description = "Globally unique S3 bucket name for static assets, logs, backups, or deployment artifacts"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.s3_assets_bucket_name))
    error_message = "s3_assets_bucket_name must be a valid globally unique S3 bucket name using lowercase letters, numbers, dots, or hyphens."
  }
}

# ------------------------------------------------------------------------------
# CloudWatch alarm configuration
# ------------------------------------------------------------------------------

variable "cloudwatch_alarm_actions" {
  description = "SNS topic ARNs or other action ARNs to notify when CloudWatch alarms change state"
  type        = list(string)
  default     = []
}

variable "asg_cpu_high_threshold" {
  description = "Average ASG CPU utilization percentage that triggers the high CPU alarm"
  type        = number
  default     = 70
}

variable "rds_cpu_high_threshold" {
  description = "Average RDS CPU utilization percentage that triggers the high CPU alarm"
  type        = number
  default     = 80
}

variable "rds_free_storage_low_threshold" {
  description = "RDS free storage threshold in bytes that triggers the low storage alarm"
  type        = number
  default     = 2147483648
}

variable "rds_database_connections_high_threshold" {
  description = "Average RDS database connection count that triggers the high connections alarm"
  type        = number
  default     = 80
}
