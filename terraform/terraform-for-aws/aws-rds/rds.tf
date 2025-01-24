# RDS Resource
resource "aws_db_subnet_group" "mariadb-subnets" {
  name        = "mariadb-subnets"
  description = "Amazon RDS subnet group"
  subnet_ids  = [aws_subnet.tf_created_vpc_private_subnet-1.id, aws_subnet.tf_created_vpc_private_subnet-2.id] // we want the rds to sit behind in the private subnet where only approved ec2 instances can access
}

# RDS Parameters
resource "aws_db_parameter_group" "tf-mariadb-parameters" {
  name        = "tf-mariadb-parameters"
  family      = "mariadb10.11"
  description = "MariaDB parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

# RDS Instance Properties
# https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/MariaDB.Concepts.VersionMgmt.html
# https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.DBInstanceClass.Support.html
# https://developer.hashicorp.com/terraform/tutorials/aws/aws-rds
resource "aws_db_instance" "tf-mariadb" {
  allocated_storage       = 20 # 20gb storage
  engine                  = "mariadb"
  engine_version          = "10.11.10"
  instance_class          = "db.t3.micro" # t2.micro deprecated
  identifier              = "mariadb"
  username                = "root"
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.mariadb-subnets.name
  parameter_group_name    = aws_db_parameter_group.tf-mariadb-parameters.name
  multi_az                = "false" # set to True for HA
  vpc_security_group_ids  = [aws_security_group.vpc_allow_mariadb.id]
  storage_type            = "gp2"
  backup_retention_period = 30
  availability_zone       = aws_subnet.tf_created_vpc_private_subnet-1.availability_zone # preferred AZ
  skip_final_snapshot     = true                                                         # skip final snapshot when doing terraform destroy
  tags = {
    Name = "tf-mariadb"
  }
}

output "rds_hostname" {
  description = "RDS MariaDB instance hostname"
  value       = aws_db_instance.tf-mariadb.address
}
