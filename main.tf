terraform {
  cloud {
    organization = "Main-123"

    workspaces {
      name = "terraform-cloud"
    }
  }

  required_version = ">= 1.1.2"
}

provider "aws" {
  region = var.region_name
}

# VPC Creation
resource "aws_vpc" "terraform_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = local.vpc_name
  }
}

# Internet Gateway for Public Subnets
resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name = local.igw_name
  }
}

# Subnet Creation for Public and Private Subnets
resource "aws_subnet" "all_subnets" {
  for_each = {
    for idx, cidr in concat(
      var.public_subnet_cidr_block,
      var.private_subnet_cidr_block
    ) : idx => {
      cidr_block        = cidr
      type              = idx < length(var.public_subnet_cidr_block) ? "public" : "private"
      availability_zone = element(var.availability_zones, idx % length(var.availability_zones))
    }
  }

  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
  map_public_ip_on_launch = each.value.type == "public" ? true : false

 tags = {
    Name = "${var.project_name}-${each.value.type}-subnet-${each.key + 1}"  # Dynamic Name without format
    Type = each.value.type
  }
}

# Public Route Table
resource "aws_route_table" "terraform_public_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }

  tags = {
    Name = local.public_route_table_name
  }
}

# Private Route Table
resource "aws_route_table" "terraform_private_rt" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = local.private_route_table_name
  }
}

# Route Table Associations for Public and Private Subnets
resource "aws_route_table_association" "all_rt_associations" {
  for_each = aws_subnet.all_subnets

  subnet_id = each.value.id

  # Use 'Type' from the subnet configuration to choose route table
  route_table_id = each.value.tags["Type"] == "public" ? aws_route_table.terraform_public_rt.id : aws_route_table.terraform_private_rt.id
}
