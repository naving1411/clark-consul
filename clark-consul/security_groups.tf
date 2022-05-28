module "service_consul_server" {
  source                = "../modules/security_groups/"
  vpc_id                = "${module.vpc_subnet.id}"
  environment           = "${var.tag_environment}"
  user                  = "${var.user}"
  name                  = "${var.name}-${var.environment}-${lookup(var.service_consul_server, "name")}"
  tag_name              = "${var.name}-${var.environment}-${lookup(var.service_consul_server, "name")}"
  rules                 = "${lookup(var.service_consul_server, "rules")}"
  description            = "${lookup(var.service_consul_server, "description")}"
}

module "service_consul_client" {
  source                = "../modules/security_groups/"
  vpc_id                = "${module.vpc_subnet.id}"
  environment           = "${var.tag_environment}"
  user                  = "${var.user}"
  name                  = "${var.name}-${var.environment}-${lookup(var.service_consul_client, "name")}"
  tag_name              = "${var.name}-${var.environment}-${lookup(var.service_consul_client, "name")}"
  rules                 = "${lookup(var.service_consul_client, "rules")}"
  description            = "${lookup(var.service_consul_client, "description")}"
}