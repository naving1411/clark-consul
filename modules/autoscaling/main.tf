variable "lt_name" {
  description = "The name of the launch template"
}
variable "lt_image_id" {
  description = "image_id used in launch template"
}
variable "lt_instance_type" {
  description = "image_id used in launch template"
}
variable "user_data" {
  description = "user_data used in launch template"
}
variable "vpc_security_group_ids" {
  description = "vpc_security_group_ids used in launch template"
}
variable "update_default_version" {
  description = "version set in launch template"
}
variable "resource_type" {
  description = "resource_type in launch template"
}
variable "lc_tag" {
  description = "resource_type in launch template"
}

variable "alarm_description" {}
variable "up_alarm_name" {}
variable "down_alarm_name" {}
variable "up_comparison_operator" {}
variable "down_comparison_operator" {}
variable "evaluation_periods" {}
variable "metric_name" {}
variable "namespace" {}
variable "period" {}
variable "statistic" {}
variable "up_threshold" {}
variable "down_threshold" {}
variable "dimensions" {}
variable "cooldown" {}
variable "remove_scaling_adjustment" {}
variable "removePolicy" {}
variable "add_scaling_adjustment" {}
variable "addPolicy" {}
variable "subnet_prefix" {}
variable "subnet_name" {}
variable "health_check_type" {}
variable "health_check_grace_period" {}
variable "asg_max_size" {}
variable "asg_desired_size" {}
variable "asg_min_size" {}
variable "asg_name" {}
variable "ec2_instance_iam_profile_name" {}
variable "key_name" {}
variable "environment" {}
variable "vpc_id" {}
variable "lh_name" {} 
variable "default_result" {} 
variable "heartbeat_timeout" {} 
variable "lifecycle_transition" {} 
variable "termination_policies" {}
/*
data "aws_subnet_ids" "subnets" {
    vpc_id = var.vpc_id
    filter {
        name   = "tag:Name"
        values = var.subnet_list
    }
}
data "aws_subnet" "load_balancer_subnet1_ids" {
 

  tags = {
    Name        = "${element(var.subnet_name,0)}"
    
  }
}

data "aws_subnet" "load_balancer_subnet2_ids" {

  

  tags = {
    Name        = "${element(var.subnet_name,1)}"
    
  }
}
*/


resource "aws_launch_template" "lt" {
  name                 = var.lt_name
  image_id             = var.lt_image_id
  instance_type        = var.lt_instance_type
  key_name             = var.key_name
  user_data            = var.user_data
  iam_instance_profile {
    name = var.ec2_instance_iam_profile_name
  }
  vpc_security_group_ids      = var.vpc_security_group_ids
  update_default_version = var.update_default_version
  tag_specifications {
    resource_type = var.resource_type
    tags = var.lc_tag
  }
}

resource "aws_autoscaling_group" "asg" {
  name     = var.asg_name
  min_size = var.asg_min_size
  desired_capacity = var.asg_desired_size
  max_size = var.asg_max_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
# vpc_zone_identifier       = "${element(aws_subnet.private.*.id, count.index)}"
  vpc_zone_identifier       = var.subnet_name
  termination_policies      = var.termination_policies
  launch_template {
    id      = aws_launch_template.lt.id
    version = aws_launch_template.lt.latest_version
  }
  depends_on = [
    aws_launch_template.lt
  ]
  lifecycle {
    ignore_changes = [ load_balancers, target_group_arns ]
  }
}

resource "aws_autoscaling_policy" "AddInstancesPolicy" {
  name                   = var.addPolicy
  scaling_adjustment     = var.add_scaling_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cooldown
  autoscaling_group_name = var.asg_name
    depends_on = [
    aws_autoscaling_group.asg
  ]
}

resource "aws_autoscaling_policy" "RemoveInstancesPolicy" {
  name                   = var.removePolicy
  scaling_adjustment     = var.remove_scaling_adjustment
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.cooldown
  autoscaling_group_name = var.asg_name
  depends_on = [
    aws_autoscaling_group.asg
  ]
}

resource "aws_cloudwatch_metric_alarm" "up_asg_alarm" {
  alarm_name          = var.up_alarm_name
  comparison_operator = var.up_comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.up_threshold

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = var.alarm_description
  alarm_actions     = [aws_autoscaling_policy.AddInstancesPolicy.arn]
  depends_on = [
    aws_autoscaling_group.asg
  ]

}

resource "aws_cloudwatch_metric_alarm" "down_asg_alarm" {
  alarm_name          = var.down_alarm_name
  comparison_operator = var.down_comparison_operator
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.down_threshold

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  alarm_description = var.alarm_description
  alarm_actions     = [aws_autoscaling_policy.RemoveInstancesPolicy.arn]
  depends_on = [
    aws_autoscaling_group.asg
  ]

}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = var.asg_name
  depends_on = [
    aws_autoscaling_group.asg
  ]
}

resource "aws_autoscaling_lifecycle_hook" "asg_lh" {
  name                   = var.lh_name
  autoscaling_group_name = var.asg_name
  default_result         = var.default_result
  heartbeat_timeout      = var.heartbeat_timeout
  lifecycle_transition   = var.lifecycle_transition
  depends_on = [
    aws_autoscaling_group.asg
  ]
}
