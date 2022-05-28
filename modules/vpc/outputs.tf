/**
 * Outputs
 */

// The VPC ID
output "id" {
  value = "${aws_vpc.main.id}"
}

// A comma-separated list of subnet IDs.
output "public_subnets" {
  value = ["${aws_subnet.public.*.id}"]
}

output "private_subnets" {
  value = ["${aws_subnet.private.*.id}"]
}

output "gateway_id" {
  value = "${aws_internet_gateway.main.id}"
}

// The default VPC security group ID.
#output "security_group" {
#  value = "${aws_vpc.main.default_security_group_id}"
#}

// The list of availability zones of the VPC.
output "availability_zones" {
  value = ["${aws_subnet.public.*.availability_zone}"]
}

