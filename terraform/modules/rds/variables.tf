variable "vpc_security_group_ids" {
  description = "The VPC security group IDs to assign to the RDS instance"
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "db_subnet_group_name" {
  description = "The DB subnet group name for the RDS instance"
  type        = string
}

variable "secret_arn" {
  description = "The ARN of the Secrets Manager secret that contains the database password"
  type        = string
}

variable "private_subnets_ids" {
  description = "Subnets ID for the RDS instance"
  type        = list(string)
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_user" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}