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
