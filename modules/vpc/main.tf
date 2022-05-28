variable "cidr" {
  description = "The CIDR block for the VPC."
}


variable "environment" {
  description = "Environment tag, e.g prod"
}


variable "tag_environment" {
  description = "Environment tag, e.g production"
}

variable "name" {
  description = "Name tag, e.g servify-stack"
}

variable "user" {
  description = "Name of the user eg: Arpit"
}

variable "public_subnets_block_1" {
  description = "List of public subnets"
}

variable "private_subnet_block_1" {
  description = "List of private subnets"
}

variable "nat_az_and_subnet_name" {}

variable "nat_eip" {}

variable "routetable_type" {
  default = ""  
}

variable "destination_cidr_block" {
  default = ""
}

variable "vpc_peering_connection_id" {
  default = ""
}

variable "vpc_endpoint_id" {
  default = ""
}

variable "transit_gateway_id" {
  default = ""
}

variable "egress_only_gateway_id" {
  default =  ""
}

variable "instance_id" {
  default =  ""
}

variable "network_interface_id" {
  default =  ""
}

variable "local_gateway_id" {
  default = ""
}
#added because of  navin comments on document

variable "instance_tenancy" {
  default = "default"
}

variable "enable_dns_support" {
  default = true
}

variable "enable_dns_hostnames" {
  default = true
}

variable "enable_classiclink" {
  default = false
}

variable "enable_classiclink_dns_support" {
  default = false
}

variable "assign_generated_ipv6_cidr_block" {
  default = false
}

variable "map_customer_owned_ip_on_launch" {
  default = false
}

variable "map_public_ip_on_launch" {
  default = false
}

variable "businessowner" {
  default = ""
}

variable "businessdepartment" {
  default = ""
}

# variable "ipv6_cidr_block" {
#   default = ""
  
# }
/**
 * VPC
 */

resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr}"
  instance_tenancy     = var.instance_tenancy
  enable_classiclink   = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    Name        = "${var.name}-${var.environment}-VPC"
    Environment = "${var.tag_environment}"
    Terraform   =  "true"
    BusinessOwner = var.businessowner
    BusinessDepartment  = var.businessdepartment
    #CreatedBy-DOC = "${var.user}"
  }
}

#internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name        = "${var.name}-${var.environment}-IG"
    Environment = "${var.tag_environment}"
    Terraform   =  "true"
    BusinessOwner = var.businessowner
    BusinessDepartment  = var.businessdepartment
    #CreatedBy-DOC = "${var.user}"

  }
}

#create public subnet

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(split("|", element(var.public_subnets_block_1, count.index)), 0)}"
  availability_zone       = "${element(split("|", element(var.public_subnets_block_1, count.index)), 1)}"
  count                   = "${length(var.public_subnets_block_1)}"
  map_public_ip_on_launch = true
  #ipv6_cidr_block         = var.ipv6_cidr_block
  #map_customer_owned_ip_on_launch  = var.map_customer_owned_ip_on_launch 

  tags = {
    Name             = "${var.name}-${var.environment}-Public-${element(split("|", element(var.public_subnets_block_1, count.index)), 2)}"
    Environment      = "${var.tag_environment}"
    Terraform        = "true"
    BusinessOwner = var.businessowner
    BusinessDepartment  = var.businessdepartment
    Tier = "Public"
    #AvailabilityZone = "${element(split("|", element(var.public_subnets_block_1, count.index)), 1)}"
    #CreatedBy-DOC = "${var.user}"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(split("|", element(var.private_subnet_block_1, count.index)), 0)}"
  availability_zone       = "${element(split("|", element(var.private_subnet_block_1, count.index)), 1)}"
  count                   = "${length(var.private_subnet_block_1)}"
  map_public_ip_on_launch = var.map_public_ip_on_launch
  #map_customer_owned_ip_on_launch  = var.map_customer_owned_ip_on_launch

  tags = {
    Name             = "${var.name}-${var.environment}-Private-${element(split("|", element(var.private_subnet_block_1, count.index)), 2)}"
    Environment      = "${var.tag_environment}"
    Terraform        = "true"
    BusinessOwner = var.businessowner
    BusinessDepartment  = var.businessdepartment
  }
}

/**
#nat gateway
resource "aws_eip" "nat_eip_1" {

  vpc = true

  lifecycle {
    create_before_destroy = true
  }

}
*/
data "aws_subnet" "nat_subnet_id" {
  availability_zone = "${element(split("|", var.nat_az_and_subnet_name), 0)}"

  tags = {
    Name = "${var.name}-${var.environment}-Public-${element(split("|",var.nat_az_and_subnet_name), 1)}"
  }

  depends_on = ["aws_subnet.public"]
}


# NAT Gateway kept in the same subnet as the ALB since ALB subnet is sized at 254
resource "aws_nat_gateway" "nat" {

  #allocation_id = "${aws_eip.nat_eip_1.id}"
  allocation_id = "${var.nat_eip}"
  subnet_id     = "${data.aws_subnet.nat_subnet_id.id}"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "${var.name}-${var.environment}-NG"
    Environment = "${var.tag_environment}"
    CreatedBy-DOC = "${var.user}"
    Terraform   =  "true"
    BusinessOwner = var.businessowner
    BusinessDepartment  = var.businessdepartment
  }
}



# Route tables


resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.name}-${var.environment}-Public"
    Environment = "${var.tag_environment}"
    Terraform   =  "true"
    CreatedBy-DOC = "${var.user}"
    BusinessOwner = var.businessowner
    BusinessDepartment  = var.businessdepartment
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "${var.name}-${var.environment}-Private"
    Environment = "${var.tag_environment}"
    Terraform   =  "true"
    CreatedBy-DOC = "${var.user}"
    BusinessOwner = var.businessowner
    BusinessDepartment  = var.businessdepartment
  }
}

#Routes

resource "aws_route" "public" {
  route_table_id         = "${aws_route_table.public.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_route" "private" {
  route_table_id         = "${aws_route_table.private.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.nat.id}"
}


# Route associations


resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets_block_1)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}


resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnet_block_1)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
}

resource "aws_main_route_table_association" "main_route_table" {
  vpc_id         = "${aws_vpc.main.id}"
  route_table_id = "${aws_route_table.public.id}"
}