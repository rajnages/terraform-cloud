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
  region = "us-east-1"
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "terraform_vpc"
    Environment = "Development"
  }
}

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name        = "terraform_igw"
    Environment = "Development"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name        = "public_subnet"
    Environment = "Development"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name        = "private_subnet"
    Environment = "Development"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_igw.id
  }
  tags = {
    Name        = "public_rt"
    Environment = "Development"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.terraform_vpc.id
  tags = {
    Name        = "private_rt"
    Environment = "Development"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}
