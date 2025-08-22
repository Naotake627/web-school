resource "aws_db_subnet_group" "web_admin" {
  name       = "web-admin-db-subnet-group"
  subnet_ids = [aws_subnet.public_a.id, aws_subnet.public_b.id]

  tags = {
    Name = "web-admin-db-subnet-group"
  }
}

resource "aws_db_instance" "web_admin" {
  identifier             = "hotel-de-work-db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "hotelworkdb"
  username               = "admin"
  password               = "adminpassword123"
  skip_final_snapshot    = true
  publicly_accessible    = true
  db_subnet_group_name   = aws_db_subnet_group.web_admin.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "hotel-de-work-db"
  }
}
