region_name               = "us-east-1"
vpc_cidr_block            = "10.0.0.0/16"
project_name              = "terraform"
version_number            = 1.0
public_subnet_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidr_block = ["10.0.12.0/24", "10.0.14.0/24", "10.0.16.0/24"]
availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
