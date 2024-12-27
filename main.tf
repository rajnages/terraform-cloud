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

resource "aws_vpc" "terraform_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(local.common_tags, { Name = "${var.environment}-VPC" })
}

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags   = merge(local.common_tags, { Name = "${var.environment}-IGW" })
}

# Subnet Configuration (Public & Private)
resource "aws_subnet" "subnet" {
  for_each = merge(
    { for idx, cidr in var.subnets.public : "public-${idx}" => cidr },
    { for idx, cidr in var.subnets.private : "private-${idx}" => cidr }
  )

  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key == "public-0" ? 0 : 1] # Assuming two AZs for simplicity  map_public_ip_on_launch = each.key == "public" ? true : false
  tags = {
    Name = "${each.key}-subnet-${substr(each.key, 0, 1)}"
  }
}

# Route Table Configuration (Public & Private)
resource "aws_route_table" "subnet_rt" {
  for_each = {
    public  = aws_internet_gateway.terraform_igw.id
    private = null
  }

  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = each.key == "public" ? each.value : null
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-${each.key}-RT"
  })
}

# Route Table Associations (Public & Private Subnets)
resource "aws_route_table_association" "subnet_association" {
  for_each = {
    for subnet_key, subnet in aws_subnet.subnet : subnet_key => subnet
  }

  subnet_id      = each.value.id
  route_table_id = aws_route_table.subnet_rt[substr(each.key, 0, 1)].id
}
