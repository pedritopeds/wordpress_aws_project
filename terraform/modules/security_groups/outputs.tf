output "cluster_sg_id" {
  value = aws_security_group.secure.id
}

output "rds_sg_id" {
  value = aws_security_group.secure.id
}