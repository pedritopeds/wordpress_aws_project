variable "desired_capacity" {
  description = "Desired number of instances in the autoscaling group"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in the autoscaling group"
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances in the autoscaling group"
  type        = number
}

variable "public_subnet_ids" {
  description = "List of subnet IDs for the autoscaling group"
  type        = list(string)
}

variable "ami_id" {
  description = "AMI ID for the launch configuration"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the launch configuration"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the launch configuration"
  type        = string
}

variable "ec2_ssh_key" {
  description = "Key pair name for the launch configuration"
  type        = string
}