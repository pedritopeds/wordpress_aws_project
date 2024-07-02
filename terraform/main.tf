#Provider AWS with the region I normally use
provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

# IAM role and policies for the EKS Cluster
resource "aws_iam_role" "iam_role" {
  name               = "eks-cluster-example"
  assume_role_policy = jsonencode({
  Version= "2012-10-17"
  Statement= [
    {
      Action= "sts:AssumeRole"
      Effect= "Allow"
      Principal= {
        Service= "eks.amazonaws.com"
      }
    },
    {
      Action= "sts:AssumeRole"
      Effect= "Allow"
      Principal= {
        Service= "ec2.amazonaws.com"
      }
    }
  ]
})
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
  ]
}


# VPC module
module "vpc" {
  source               = "./modules/vpc"
  vpc_id               = module.vpc.vpc_id
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

# Security Groups module
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

# Secrets Manager module
module "secrets_manager" {
  source      = "./modules/secrets_manager"
  secret_name = "${var.project_name}-db-secret"
  username    = "admin"
}

# Data Source for AWS Secrets Manager
data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = module.secrets_manager.db_secret_arn
}

# RDS module
module "rds" {
  source                 = "./modules/rds"
  private_subnets_ids    = module.vpc.private_subnet_ids
  db_name                = "${var.project_name}-db"
  db_user                = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string).username
  db_password            = module.secrets_manager.db_password
  secret_arn             = module.secrets_manager.db_secret_arn
  vpc_id                 = module.vpc.vpc_id
  vpc_security_group_ids = [module.security_groups.rds_sg_id]
  db_subnet_group_name   = module.vpc.db_subnet_group_name
}

# EKS Cluster module
module "eks" {
  source           = "./modules/eks"
  name             = "${var.project_name}-cluster"
  subnet_ids       = module.vpc.private_subnet_ids
  cluster_role_arn = aws_iam_role.iam_role.arn
  ec2_ssh_key         = "ec2_ssh_key"
}

#Data Source what kubernetes provider needs to authenticate into the cluster
data "aws_eks_cluster_auth" "eksauth" {
  name = "${var.project_name}-cluster"
}

# WordPress module
module "wordpress" {
  source      = "./modules/wordpress"
  ekscluster  = module.eks.eks_cluster_id
  db_name     = module.rds.db_name
  db_host     = module.rds.rds_endpoint
  db_username = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string).username
  db_password = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string).password
}

# Auto Scaling module
module "autoscaling" {
  source            = "./modules/autoscaling"
  desired_capacity  = 1
  max_size          = 2
  min_size          = 1
  public_subnet_ids = module.vpc.public_subnet_ids
  ami_id            = "ami-04b70fa74e45c3917"
  instance_type     = "t2.micro"
  security_group_id = module.security_groups.cluster_sg_id
  ec2_ssh_key          = "ec2_ssh_key"
}

# Monitoring module
module "monitoring" {
  source                 = "./modules/monitoring"
  log_group_name         = "/aws/eks/wordpress"
  log_retention_days     = 14
  alarm_name             = "high_cpu_utilization"
  cpu_threshold          = 80
  autoscaling_group_name = module.autoscaling.autoscaling_group_name
}

# CloudFront module
module "cloudfront" {
  source      = "./modules/cloudfront"
  environment = "prod"
}

