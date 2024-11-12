# bucket_name = "dev-proj-1-jenkins-remote-state-bucket-12345"

vpc_cidr            = "11.0.0.0/16"
vpc_name            = "dev-proj-jenkins-ap-south-vpc-1"
cidr_public_subnet  = ["11.0.1.0/24", "11.0.2.0/24"]
cidr_private_subnet = ["11.0.3.0/24", "11.0.4.0/24"]
availability_zone   = ["ap-south-1a", "ap-south-1b"]

public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDp/sCl4oYc2hwLLrXLSW5tHddY4Vv3RwOgyBCj1L0Gk zul@Abdullas-MacBook-Pro.local"
ec2_ami_id = "ami-0dee22c13ea7a9a67"

domain_name = "zulq.dev"
