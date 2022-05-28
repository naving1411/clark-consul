# --------------------------------------------
# GLOBAL VARIABLES
variable "name" {
  description = "the name of your stack, e.g. \"test\""
  default = "test"
}

variable "user" {
  description = "the name of user, e.g. \"arpit\""
}

variable "aws_profile" {
  description = "Name of the AWS profile to be used for the current terraform run"
  default = "default"
}

variable "environment" {
  description = "the name of your environment, e.g. \"Prod\", \"UAT\""
}

variable "tag_environment" {
  description = "the name of your environment, e.g. \"Production\", \"UAT\""
}

variable "region" {
  description = "the AWS region in which resources are created, you must set the availability_zones variable as well if you define this value to something other than the default"
}

variable "terraform_s3_bucket" {
  description = "the name of bucket"
}

variable "consul_server_asg_tag" {}
variable "consul_client_asg_tag" {}
variable "consul_server_asg" {}
variable "consul_client_asg" {}
variable "aws_amis" {}
variable "key_name" {}
variable "ec2_instance_iam_profile_name" {}
variable "service_consul_server" {}
variable "service_consul_client" {}
variable "nat_eip" {}
variable "cidr" {}
variable "public_subnets_block_1" {}
variable "private_subnets_block_1" {}
variable "nat_az_and_subnet_name" {}