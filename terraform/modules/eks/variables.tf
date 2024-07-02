variable "cluster_role_arn" {
  description = "IAM role ARN for the EKS cluster"
  type        = string
}

variable "name" {
  description = "The name of the EKS Cluster"
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "ec2_ssh_key" {
  description = "The name of the SSH key pair to use for EC2 instances"
  type        = string
}