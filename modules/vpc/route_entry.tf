#NOTE: Targets carrier gateway , Outpost Local Gateway and Gateway Load Balancer Endpoint are not supported this terraform code . 
resource "aws_route" "vpc_peering" {
  count = "${var.vpc_peering_connection_id != ""  ? 1 : 0}"
  route_table_id            = "${var.routetable_type == "public"  ? aws_route_table.public.id : aws_route_table.private.id}" 
  destination_cidr_block    = var.destination_cidr_block
  vpc_peering_connection_id = var.vpc_peering_connection_id
}

resource "aws_route" "vpc_endpoint" {
  count = "${var.vpc_endpoint_id != ""  ? 1 : 0}"
  route_table_id            = "${var.routetable_type == "public"  ? aws_route_table.public.id : aws_route_table.private.id}" 
  destination_cidr_block    = var.destination_cidr_block
  vpc_endpoint_id = var.vpc_endpoint_id
}

resource "aws_route" "transit_gateway" {
  count = "${var.transit_gateway_id != ""  ? 1 : 0}"
  route_table_id            = "${var.routetable_type == "public"  ? aws_route_table.public.id : aws_route_table.private.id}" 
  destination_cidr_block    = var.destination_cidr_block
  transit_gateway_id = var.transit_gateway_id
}

resource "aws_route" "egress_only_gateway" {
  count = "${var.egress_only_gateway_id != ""  ? 1 : 0}"
  route_table_id            = "${var.routetable_type == "public"  ? aws_route_table.public.id : aws_route_table.private.id}" 
  destination_cidr_block    = var.destination_cidr_block
  egress_only_gateway_id = var.egress_only_gateway_id
}

resource "aws_route" "instance_id" {
  count = "${var.instance_id != ""  ? 1 : 0}"
  route_table_id            = "${var.routetable_type == "public"  ? aws_route_table.public.id : aws_route_table.private.id}" 
  destination_cidr_block    = var.destination_cidr_block
  instance_id = var.instance_id
}

resource "aws_route" "network_interface" {
  count = "${var.network_interface_id != ""  ? 1 : 0}"
  route_table_id            = "${var.routetable_type == "public"  ? aws_route_table.public.id : aws_route_table.private.id}" 
  destination_cidr_block    = var.destination_cidr_block
  network_interface_id = var.network_interface_id
}

resource "aws_route" "local_gateway" {
  count = "${var.local_gateway_id != ""  ? 1 : 0}"
  route_table_id            = "${var.routetable_type == "public"  ? aws_route_table.public.id : aws_route_table.private.id}" 
  destination_cidr_block    = var.destination_cidr_block
  local_gateway_id = var.local_gateway_id
}
