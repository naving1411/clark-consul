output "sg_id" {
  value = "${aws_security_group.main.id}"
}

# output "sg_internal_id" {
#   value = "${aws_security_group.internal_all_traffic.id}"
# }

# output "sg_external-ssh_id" {
#     value = "${aws_security_group.external-ssh.id}"
# }
