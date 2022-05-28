# clark-consul


# Automate the deployment and management of a Consul cluster:-

To automate the consul-cluster, terraform and jenkinsfile is used. AWS Autoscaling will help for High Availability.

Terraform :- VPC, Subnet in three AZs, NAT and other networking services are used. 
			 In this VPC, AutoScaling group created for Consul server and client. 

Jenkinsfile :- Jenkinsfile created for pipeline. If any change required, update the code and run the jenkins job. 








