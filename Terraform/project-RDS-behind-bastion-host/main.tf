data "template_file" "user_data" {
  template = "${file("${path.module}/userdata.tpl")}"
}

resource "aws_vpc" "mariadb-vpc-from-terraform" {
  cidr_block       = "${var.vpc_cidr}"
  enable_dns_hostnames = "true"
  tags {
    Name = "mariadb-vpc-from-terraform"
  }
}

resource "aws_internet_gateway" "mariadb-ig-from-terraform" {
  vpc_id = "${aws_vpc.mariadb-vpc-from-terraform.id}"

  tags {
    Name = "mariadb-ig-from-terraform"
  }
}

resource "aws_subnet" "mariadb-public-subnet-from-terraform" {
  vpc_id     = "${aws_vpc.mariadb-vpc-from-terraform.id}"
  cidr_block = "${var.public_subnet_cidr}"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = "true"
  
  tags {
    Name = "mariadb-public-subnet-from-terraform"
  }
}

resource "aws_route_table" "public_route_table_for-vpc-from-terraform" {
  vpc_id = "${aws_vpc.mariadb-vpc-from-terraform.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.mariadb-ig-from-terraform.id}"
  }

  tags {
    Name = "public_route_table_for-vpc-from-terraform"
  }
}

resource "aws_route_table_association" "public_route_subnet_association" {
  subnet_id      = "${aws_subnet.mariadb-public-subnet-from-terraform.id}"
  route_table_id = "${aws_route_table.public_route_table_for-vpc-from-terraform.id}"
}

resource "aws_security_group" "bastion-host-sg-from-terraform" {
  name        = "bastion - port 22 - terraform"
  description = "Allow port 22 from terraform."
  
  vpc_id = "${aws_vpc.mariadb-vpc-from-terraform.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

data "aws_ami" "amz_ami_hvm_latest" {
  most_recent      = true
  
  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }
}

resource "aws_instance" "bastion-host-instance-terraform" {
  ami           = "${data.aws_ami.amz_ami_hvm_latest.id}"
  instance_type = "t2.micro"
  key_name = "mariadb-work-key-pair"
  vpc_security_group_ids = ["${aws_security_group.bastion-host-sg-from-terraform.id}"]
  subnet_id = "${aws_subnet.mariadb-public-subnet-from-terraform.id}"
  associate_public_ip_address = "true"
  user_data = "${data.template_file.user_data.rendered}"

  tags {
    Name = "bastion-host-instance-terraform"
  }
}

resource "aws_subnet" "mariadb-private-subnet-1-from-terraform" {
  vpc_id     = "${aws_vpc.mariadb-vpc-from-terraform.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  
  tags {
    Name = "mariadb-private-subnet-1-from-terraform"
  }
}

resource "aws_subnet" "mariadb-private-subnet-2-from-terraform" {
  vpc_id     = "${aws_vpc.mariadb-vpc-from-terraform.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  
  tags {
    Name = "mariadb-private-subnet-2-from-terraform"
  }
}

resource "aws_route_table_association" "private_route_subnet_association-1" {
  subnet_id      = "${aws_subnet.mariadb-private-subnet-1-from-terraform.id}"
  route_table_id = "${aws_vpc.mariadb-vpc-from-terraform.main_route_table_id}"
}

resource "aws_route_table_association" "private_route_subnet_association-2" {
  subnet_id      = "${aws_subnet.mariadb-private-subnet-2-from-terraform.id}"
  route_table_id = "${aws_vpc.mariadb-vpc-from-terraform.main_route_table_id}"
}

resource "aws_security_group" "rds-db-sg-from-terraform" {
  name        = "rds-db-sg-from-terraform"
  description = "Allow port 3306 only from bastion host."
  
  vpc_id = "${aws_vpc.mariadb-vpc-from-terraform.id}"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = ["${aws_security_group.bastion-host-sg-from-terraform.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds-db-subnet-group-from-terraform" {
  name       = "rds-db-subnet-group-from-terraform"
  subnet_ids = ["${aws_subnet.mariadb-private-subnet-1-from-terraform.id}", "${aws_subnet.mariadb-private-subnet-2-from-terraform.id}"]

  tags {
    Name = "DB subnet group form terraform"
  }
}

resource "aws_db_instance" "rds-mariadb-from-terraform" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mariadb"
  engine_version       = "10.0.24"
  instance_class       = "db.t2.micro"
  name                 = "mariadbterraform"
  username             = "mariadb"
  password             = "awsmaria"
  db_subnet_group_name = "rds-db-subnet-group-from-terraform"
  vpc_security_group_ids = ["${aws_security_group.rds-db-sg-from-terraform.id}"]
  skip_final_snapshot = "true"
}


























































