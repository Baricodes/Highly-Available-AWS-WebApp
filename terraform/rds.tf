# ------------------------------------------------------------------------------
# RDS subnet group (private DB subnets)
# ------------------------------------------------------------------------------

resource "aws_db_subnet_group" "webapp" {
  name       = "webapp-db-subnet-group"
  subnet_ids = [aws_subnet.private_db_a.id, aws_subnet.private_db_b.id]

  tags = {
    Name = "webapp-db-subnet-group"
  }
}

# ------------------------------------------------------------------------------
# RDS MySQL instance (Multi-AZ, private subnets, db-sg)
# ------------------------------------------------------------------------------

resource "aws_db_instance" "webapp" {
  identifier     = "webapp-db"
  engine         = "mysql"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  username = var.db_master_username
  password = var.db_master_password

  multi_az                = true
  db_subnet_group_name    = aws_db_subnet_group.webapp.name
  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  publicly_accessible     = false
  backup_retention_period = 7
  storage_encrypted       = true

  skip_final_snapshot = true

  tags = {
    Name = "webapp-db"
  }
}
