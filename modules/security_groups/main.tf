variable "name" {
  description = "The name of the security groups serves as a prefix, e.g stack"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "environment" {
  description = "The environment, used for tagging, e.g prod"
}

variable "user" {
  description = "User"
}

variable "tag_name" {
  
}

# variable "ip" {
#   type        = "list"
  
# }

# variable "ports" {
#   type        = "list"
  
# }

variable "description" {
  
}

# variable "source_security_group_id" {
#   type = "string"
#   default = ""
# }

variable "rules" {
}

resource "aws_security_group" "main" {
  name       = "${format("%s-SG", var.name)}"
  vpc_id     = "${var.vpc_id}"
  description = "${var.description}"

  tags = {
    Name        = "${format("%s-SG", var.tag_name)}"
    Environment = "${var.environment}"
    Terraform   = "true"
    #CreatedBy = "${var.user}"
  }

}
#source_security_group_id


#data "aws_security_groups" "source_security_group" {
#  tags = {
#    Name = "${format("%s-SG", var.source_security_name)}"
#    Environment = "${var.environment}"
#  }
#}

resource "aws_security_group_rule" "main_igress_traffic" {
  #count = "${var.ip[0] != "" ? "${length(var.ports)}" : 0}"
  count       = "${length(var.rules)}"
  type        = "ingress"
  from_port   = "${lookup(var.rules[count.index], "from_port")}"
  #from_port   = tonumber(var.ports[count.index])
  to_port     = "${lookup(var.rules[count.index], "to_port")}"
  protocol    = "tcp"
  cidr_blocks = "${lookup(var.rules[count.index], "ip")}"

  description = "${lookup(var.rules[count.index], "description")}"

  security_group_id = "${aws_security_group.main.id}"
}


resource "aws_security_group_rule" "main_egress_traffic" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.main.id}"
}
