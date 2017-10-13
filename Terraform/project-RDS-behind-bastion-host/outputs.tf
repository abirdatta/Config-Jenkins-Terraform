output "vpc_id" {
  value = "${aws_vpc.mariadb-vpc-from-terraform.id}"
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.mariadb-ig-from-terraform.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.mariadb-public-subnet-from-terraform.id}"
}

output "public_route_table_id" {
  value = "${aws_route_table.public_route_table_for-vpc-from-terraform.id}"
}

output "bastion_host_security_group_id" {
  value = "${aws_security_group.bastion-host-sg-from-terraform.id}"
}

output "ami-id" {
  value = "${data.aws_ami.amz_ami_hvm_latest.id}"
}

output "bastion-host-instance-id" {
  value = "${aws_instance.bastion-host-instance-terraform.id}"
}

output "bastion-host-instance-public_dns" {
  value = "${aws_instance.bastion-host-instance-terraform.public_dns}"
}

output "bastion-host-instance-public_ip" {
  value = "${aws_instance.bastion-host-instance-terraform.public_ip}"
}

output "private-route-table-id" {
  value = "${aws_vpc.mariadb-vpc-from-terraform.main_route_table_id}"
}

output "private_subnet_id_us-east-1b" {
  value = "${aws_subnet.mariadb-private-subnet-1-from-terraform.id}"
}

output "private_subnet_id_us-east-1c" {
  value = "${aws_subnet.mariadb-private-subnet-2-from-terraform.id}"
}

output "rds-db-sg-from-terraform id" {
  value = "${aws_security_group.rds-db-sg-from-terraform.id}"
}

output "rds-db-subnet-group-from-terraform id" {
  value = "${aws_db_subnet_group.rds-db-subnet-group-from-terraform.id}"
}

output "RDS DB instance endpoint" {
  value = "${aws_db_instance.rds-mariadb-from-terraform.endpoint}"
}

output "RDS DB instance database name" {
  value = "${aws_db_instance.rds-mariadb-from-terraform.name}"
}

output "RDS DB instance username" {
  value = "${aws_db_instance.rds-mariadb-from-terraform.username}"
}

output "RDS DB instance availability_zone" {
  value = "${aws_db_instance.rds-mariadb-from-terraform.availability_zone}"
}

