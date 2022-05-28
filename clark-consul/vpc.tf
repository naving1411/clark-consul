module "vpc_subnet" {
  source             = "../modules/vpc/"
  user               = "${var.user}"
  nat_eip            = "${var.nat_eip}"
  name               = "${var.name}"
  cidr               = "${var.cidr}"
  public_subnets_block_1     = "${var.public_subnets_block_1}"
  private_subnet_block_1     = "${var.private_subnets_block_1}"
  environment        = "${var.environment}"
  tag_environment    = var.tag_environment
  nat_az_and_subnet_name     = "${var.nat_az_and_subnet_name}"
}
