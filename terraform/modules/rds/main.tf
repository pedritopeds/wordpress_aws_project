#RDS DB with the password managed on Secrets Manager
resource "aws_db_instance" "wordpressdb" {
  identifier         = "wordpressdb"
  allocated_storage          = 20
  max_allocated_storage      = 40
  storage_type               = "gp2"
  engine                     = "mysql"
  engine_version             = "5.7.44"
  instance_class             = "db.t3.micro"
  username                   = var.db_user
  password                   = jsondecode(data.aws_secretsmanager_secret_version.db_secret_version.secret_string).password
  parameter_group_name       = "default.mysql5.7"
  skip_final_snapshot        = true
  auto_minor_version_upgrade = true
  vpc_security_group_ids     = var.vpc_security_group_ids
  db_subnet_group_name       = var.db_subnet_group_name
  publicly_accessible        = true
  port                       = 3306
  
  tags = {
    Name = "WordPress-DB"
  }
}

data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = var.secret_arn
}

resource "aws_db_subnet_group" "main" {
  name       = "wordpress-subnet-group"
  subnet_ids = var.private_subnets_ids

  tags = {
    Name = "wordpress-db-subnet-group"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow RDS traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}