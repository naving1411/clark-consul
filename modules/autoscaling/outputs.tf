output "lt_id" {
    #value = "${aws_instance.main.*.id}"
    value = aws_launch_template.lt.id
}

output "lt_version" {
    #value = "${aws_instance.main.*.id}"
    value = aws_launch_template.lt.latest_version
}

output "addPolicy_arn" {
    value = aws_autoscaling_policy.AddInstancesPolicy.*.arn
}

output "removePolicy_arn" {
    value = aws_autoscaling_policy.RemoveInstancesPolicy.arn
}



