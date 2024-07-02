output "vpc_id" {
  value = module.vpc.vpc_id
}

output "rds_security_group_id" {
  value = module.security_groups.rds_sg_id
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "db_secret_arn" {
  value = module.secrets_manager.db_secret_arn
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  value = module.cloudfront.cloudfront_domain_name
}

output "bucket_name" {
  value = module.cloudfront.bucket_name
}

output "bucket_regional_domain_name" {
  value = module.cloudfront.bucket_regional_domain_name
}