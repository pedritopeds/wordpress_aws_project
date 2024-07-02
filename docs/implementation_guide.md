# Implementation Guide

## Prerequisites
- AWS account with all appropriate permissions, and if necessary, even the K8s RBAC Authorization to pods, services and deployments.
- AWS EC2 Key Pair needs to be created and added to the project. This is referenced like variable in the project as "ec2_ssh_key".
- Terraform installed

## Implementation steps
1. Clone the repository.
2. Configure the variables in `variables.tf`.
3. Run `terraform init`, `terraform plan` and `terraform apply`.
4. Check the resources provisioned in AWS and the web access on the App.