# DB Subnet Group
resource "aws_db_subnet_group" "wordpress" {
  name       = "${var.project_name}-subnet-group"
  subnet_ids = [var.private_subnet_a_id, var.private_subnet_b_id]

  tags = { Name = "${var.project_name}-subnet-group" }
}

# RDS Instance
resource "aws_db_instance" "wordpress" {
  identifier           = "${var.project_name}-mysql-db"
  engine               = "mysql"
  engine_version       = "8.4.3"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  storage_type         = "gp2"

  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.wordpress.name
  vpc_security_group_ids = [var.rds_sg_id]
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = { Name = "${var.project_name}-mysql-db" }
}