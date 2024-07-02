variable "db_name" {
  description = "The database host for WordPress"
  type        = string
}

variable "db_host" {
  description = "The database host for WordPress"
  type        = string
}

variable "db_username" {
  description = "The database username for WordPress"
  type        = string
}

variable "db_password" {
  description = "The database password for WordPress"
  type        = string
  sensitive   = true
}

variable "ekscluster" {
  type = string
}