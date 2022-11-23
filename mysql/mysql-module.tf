# Create DB subnet group and add the public subnet 
resource "aws_db_subnet_group" "rds-public-subnet" {
  name = "rds-public-subnet-group"
  subnet_ids = values(aws_subnet.public-subnets)[*].id
}

# Create a new db parameter group
resource "aws_db_parameter_group" "mydb_param_group" {
  name   = "mydbparam"
  family = "mysql5.7"

  parameter {
    name  = "net_buffer_length"
    value = "1048576"
  }

  parameter {
    name  = "max_allowed_packet"
    value = "1073741824"
  }
}


resource "aws_db_instance" "my_test_mysql" {
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7"
  instance_class              = "db.t3.micro"
  db_name                     = "infodb"
  username                    = "admin"
  password                    = "admin123"
  #parameter_group_name        = "default.mysql5.7"
  db_subnet_group_name        = "${aws_db_subnet_group.rds-public-subnet.name}"
  vpc_security_group_ids      = ["${aws_security_group.public-sg.id}"]
  multi_az                    = false
  skip_final_snapshot         = true
  parameter_group_name        = aws_db_parameter_group.mydb_param_group.name
  publicly_accessible         = true

  provisioner "local-exec" {
    command = "mysql --host=${self.address} --port=${self.port} --user=${self.username} --password=${self.password} < /home/vagrant/infodb/mysqldump_april282020.txt"
  }
}