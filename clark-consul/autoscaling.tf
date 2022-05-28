module "consul_server_asg" {
  source                        = "../modules/autoscaling/"
  vpc_id                        = module.vpc_subnet.id
  lt_name                       = lookup(var.consul_server_asg, "lt_name")
  lt_image_id                   = lookup(var.aws_amis, "consul")
  lt_instance_type              = lookup(var.consul_server_asg, "lt_instance_type")
  key_name                      = var.key_name
  user_data                     = filebase64("scripts/user-data-server.sh")
  ec2_instance_iam_profile_name = var.ec2_instance_iam_profile_name
  vpc_security_group_ids        = [module.service_consul_server.sg_id]
  #update_default_version = "${lookup(var.consul_server_asg, "update_default_version")}"
  update_default_version    = "true"
  resource_type             = lookup(var.consul_server_asg, "resource_type")
  #lc_tag                    = lookup(var.consul_server_asg, "lc_tag")
  lc_tag                    = var.consul_server_asg_tag
  asg_name                  = lookup(var.consul_server_asg, "asg_name")
  asg_min_size              = lookup(var.consul_server_asg, "asg_min_size")
  asg_desired_size          = lookup(var.consul_server_asg, "asg_desired_size")
  asg_max_size              = lookup(var.consul_server_asg, "asg_max_size")
  health_check_grace_period = lookup(var.consul_server_asg, "health_check_grace_period")
  health_check_type         = lookup(var.consul_server_asg, "health_check_type")
  subnet_name             = ["${var.name}-${var.environment}-Private-App1","${var.name}-${var.environment}-Private-App2","${var.name}-${var.environment}-Private-App3"]
  subnet_prefix             = "${var.name}-${var.environment}"
  addPolicy                 = lookup(var.consul_server_asg, "addPolicy")
  add_scaling_adjustment    = lookup(var.consul_server_asg, "add_scaling_adjustment")
  removePolicy              = lookup(var.consul_server_asg, "removePolicy")
  remove_scaling_adjustment = lookup(var.consul_server_asg, "remove_scaling_adjustment")
  cooldown                  = lookup(var.consul_server_asg, "cooldown")
  up_alarm_name             = lookup(var.consul_server_asg, "up_alarm_name")
  down_alarm_name           = lookup(var.consul_server_asg, "down_alarm_name")
  up_comparison_operator    = "GreaterThanOrEqualToThreshold"
  down_comparison_operator  = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  up_threshold              = "65"
  down_threshold            = "40"
  termination_policies      = ["OldestInstance","OldestLaunchTemplate"]
  dimensions = {
    AutoScalingGroupName = "${lookup(var.consul_server_asg, "asg_name")}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"

  environment = var.environment
  lh_name                   = lookup(var.consul_server_asg, "lh_name")
  default_result            = lookup(var.consul_server_asg, "default_result")
  heartbeat_timeout         = lookup(var.consul_server_asg, "heartbeat_timeout")
  lifecycle_transition      = lookup(var.consul_server_asg, "lifecycle_transition")
}


module "consul_client_asg" {
  source                        = "../modules/autoscaling/"
  vpc_id                        = module.vpc_subnet.id
  lt_name                       = lookup(var.consul_client_asg, "lt_name")
  lt_image_id                   = lookup(var.aws_amis, "consul")
  lt_instance_type              = lookup(var.consul_client_asg, "lt_instance_type")
  key_name                      = var.key_name
  user_data                     = filebase64("scripts/user-data-client.sh")
  ec2_instance_iam_profile_name = var.ec2_instance_iam_profile_name
  vpc_security_group_ids        = [module.service_consul_client.sg_id]
  #update_default_version = "${lookup(var.consul_client_asg, "update_default_version")}"
  update_default_version    = "true"
  resource_type             = lookup(var.consul_client_asg, "resource_type")
  #lc_tag                    = lookup(var.consul_client_asg, "lc_tag")
  lc_tag                    = var.consul_client_asg_tag
  asg_name                  = lookup(var.consul_client_asg, "asg_name")
  asg_min_size              = lookup(var.consul_client_asg, "asg_min_size")
  asg_desired_size          = lookup(var.consul_client_asg, "asg_desired_size")
  asg_max_size              = lookup(var.consul_client_asg, "asg_max_size")
  health_check_grace_period = lookup(var.consul_client_asg, "health_check_grace_period")
  health_check_type         = lookup(var.consul_client_asg, "health_check_type")
  subnet_name             = ["${var.name}-${var.environment}-Private-App1","${var.name}-${var.environment}-Private-App2","${var.name}-${var.environment}-Private-App3"]
  subnet_prefix             = "${var.name}-${var.environment}"
  addPolicy                 = lookup(var.consul_client_asg, "addPolicy")
  add_scaling_adjustment    = lookup(var.consul_client_asg, "add_scaling_adjustment")
  removePolicy              = lookup(var.consul_client_asg, "removePolicy")
  remove_scaling_adjustment = lookup(var.consul_client_asg, "remove_scaling_adjustment")
  cooldown                  = lookup(var.consul_client_asg, "cooldown")
  up_alarm_name             = lookup(var.consul_client_asg, "up_alarm_name")
  down_alarm_name           = lookup(var.consul_client_asg, "down_alarm_name")
  up_comparison_operator    = "GreaterThanOrEqualToThreshold"
  down_comparison_operator  = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  up_threshold              = "65"
  down_threshold            = "40"
  termination_policies      = ["OldestInstance","OldestLaunchTemplate"]
  dimensions = {
    AutoScalingGroupName = "${lookup(var.consul_client_asg, "asg_name")}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"

  environment = var.environment
  lh_name                   = lookup(var.consul_client_asg, "lh_name")
  default_result            = lookup(var.consul_client_asg, "default_result")
  heartbeat_timeout         = lookup(var.consul_client_asg, "heartbeat_timeout")
  lifecycle_transition      = lookup(var.consul_client_asg, "lifecycle_transition")
}