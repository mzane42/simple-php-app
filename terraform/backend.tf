### Variables
variable db_storage {
  default = "5"
}

variable db_engine {
  default = "mysql"
}

variable db_instance_type {
  default = "db.t1.micro"
}

variable db_user {
  default = "admin"
}

variable db_password {
  default = "devops2017"
}

# The name of the database is already in the snapshot
variable db_snapshot {
  default = "arn:aws:rds:eu-west-1:446240913558:snapshot:devops-crashcourse"
}

### Resources
resource "aws_db_subnet_group" "mysql" {
   name = "main"
   subnet_ids = ["${aws_subnet.public.*.id}"]
   tags {
    Name = "test"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6.35"
  instance_class       = "db.t1.micro"
  name                 = "${aws_db_subnet_group.mysql.name}"
  username             = "${var.db_user}"
  password             = "${var.db_password}"
  db_subnet_group_name = "${aws_db_subnet_group.mysql.name}"
  parameter_group_name = "default.mysql5.6"
}

### Outputs
output "mysql_host" {
 value = "${aws_db_instance.mysql.address}"
# see https://www.terraform.io/intro/getting-started/outputs.html
}

output "mysql_db" {
  value = "${aws_db_instance.mysql.database_name}"
}

output "mysql_user" {
  value = "${aws_db_instance.mysql.database_user}"
}

output "mysql_password" {
  value = "${aws_db_instance.mysql.password}"
}
