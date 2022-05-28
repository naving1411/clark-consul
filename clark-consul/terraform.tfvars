/***
1. Create IAM role that need to be attach with instances.
2. Create NAT GATEWAY Elastic ip
3. Create ssh key
4. AMI shoud be ready to use
5. ACM ssl certificate domain
6. S3 bucket to store statefile
Pre created ARN
*/

# --------------------------------------------
# GLOBAL VARIABLES
name = "Clark-Consul"

## user parameter not yet used, it is just to specify that the infra is create by terraform
user = "terraform"

# aws_profile = ""
environment = "Test"   # TODO: Environment is Production on EC2 instances
tag_environment = "Test"
region = "us-west-2"
terraform_s3_bucket = "clark-consul-test-navin"

# --------------------------------------------
# VPC and SUBNET VARIABLES



cidr = "10.30.0.0/16"
public_subnets_block_1 = ["10.30.1.0/24|us-west-2a|App1","10.30.3.0/24|us-west-2b|App2","10.30.5.0/24|us-west-2c|App3"]
private_subnets_block_1 = ["10.30.0.0/24|us-west-2a|App1","10.30.2.0/24|us-west-2b|App2","10.30.4.0/24|us-west-2c|App3"]
nat_az_and_subnet_name = "us-west-2a|App1"

## This is a pre-created Elastic IP for NAT gateway since we don't want to change nat gateway IP in case we want to destroy the system and spin up again for weekends/holidays.

nat_eip = "eipalloc-08672d46d83757ba2"

# --------------------------------------------
# LOAD BALANCER VARIABLES

ssl_policy = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

http_listener_redirect_https = {
  type = "redirect"
  field = "path-pattern"
  path = "/"
  priority = 99
}

### Will search for arn in ACM for below mentioned domains
ssl_certificate_domain = "*.clark.tech"

# api_host_header = ""

### Provide list of hosts in listner
https_listener_default = {
  type = "forward"
  field = "host-header"
  api_host_header = ""
  priority = "99"
}
# --------------------------------------------
# TARGET GROUP VARIABLES

/*
default_tg =  {
  name = "US-Main-Prod-Landing",
  path = "/healthCheck"
}
*/
# aws_instances_ids

# --------------------------------------------
# EC2 VARIABLES
# croma uat api server ami - ami-01aa0fe5eb39fcdb2
# croma prod core api server ami - ami-05c5811fc920f3e2b
key_name = "us-west-2-dev"

#you can add IAM role in instance.tf instaed of using below variable
ec2_instance_iam_profile_name = "DefaultSSMRole"

iam_programmatic_role = "DefaultSSMRole"
iam_devops_role = "DefaultSSMRole"

# enable_deletion_protection = "false"

ec2_instance_ebs_optimized = "false"

ec2_associate_public_ip_address = "false"

aws_amis = {
  "consul" = "ami-0a21c954f0e993dd1"
}

instance_types = {
  "consul" = "t3a.micro"
}


# --------------------------------------------
# EBS VARIABLES

## We can have one single size for root volume
root_volume_sizes = {
  "consul" = 10
}


######autoscaling###
consul_server_asg = {
  lt_name                   = "Clark-Consul-Server",
  lt_instance_type          = "t3a.micro",
  update_default_version    = "true",
  resource_type             = "instance",
  asg_name                  = "Clark-Consul-Server-AS",
  asg_min_size              = "3",
  asg_desired_size          = "3",
  asg_max_size              = "4",
  health_check_grace_period = 60,
  health_check_type         = "ELB",
  addPolicy                 = "ConsulServerAddInstancesPolicy",
  removePolicy              = "ConsulServerRemoveInstancesPolicy",
  add_scaling_adjustment    = 1,
  remove_scaling_adjustment = -1,
  cooldown                  = 60,
  lh_name                   = "Clark-Consul-Server-lh",
  default_result            = "ABANDON",
  heartbeat_timeout         = "600",
  lifecycle_transition      = "autoscaling:EC2_INSTANCE_LAUNCHING",
  up_alarm_name             = "consulServer_avg_cpu_ge_65",
  down_alarm_name           = "consulServer_avg_cpu_lt_40"
}
consul_server_asg_tag = {
    Name          = "consulServer-AS"
}

######autoscaling###
consul_client_asg = {
  lt_name                   = "Clark-Consul-Client",
  lt_instance_type          = "t3a.micro",
  update_default_version    = "true",
  resource_type             = "instance",
  asg_name                  = "Clark-Consul-Client-AS",
  asg_min_size              = "3",
  asg_desired_size          = "3",
  asg_max_size              = "4",
  health_check_grace_period = 60,
  health_check_type         = "ELB",
  addPolicy                 = "ConsulClientAddInstancesPolicy",
  removePolicy              = "ConsulClientRemoveInstancesPolicy",
  add_scaling_adjustment    = 1,
  remove_scaling_adjustment = -1,
  cooldown                  = 60,
  lh_name                   = "Clark-Consul-Client-lh",
  default_result            = "ABANDON",
  heartbeat_timeout         = "600",
  lifecycle_transition      = "autoscaling:EC2_INSTANCE_LAUNCHING",
  up_alarm_name             = "consulClient_avg_cpu_ge_65",
  down_alarm_name           = "consulClient_avg_cpu_lt_40"
}
consul_client_asg_tag = {
    Name          = "consulClient-AS"
}