variable "log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs in CloudWatch"
  type        = number
}

variable "alarm_name" {
  description = "Name of the CloudWatch alarm"
  type        = string
}

variable "cpu_threshold" {
  description = "Threshold for CPU utilization alarm"
  type        = number
}

variable "autoscaling_group_name" {
  description = "Name of the autoscaling group to monitor"
  type        = string
}