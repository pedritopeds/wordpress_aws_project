output "rds_endpoint" {
  value = aws_db_instance.wordpressdb.endpoint
}

output "db_name" {
  value = aws_db_instance.wordpressdb.db_name
}