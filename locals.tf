locals {
  vpc_name               = format("%s-vpc", var.project_name)
  igw_name               = format("%s-igw", var.project_name)
  public_subnet_name     = [for idx in range(length(var.public_subnet_cidr_block)) : format("%s-public-subnet-%d", var.project_name, idx)]
  private_subnet_name    = [for idx in range(length(var.private_subnet_cidr_block)) : format("%s-private-subnet-%d", var.project_name, idx)]
  public_route_table_name = format("%s-public-rt", var.project_name)
  private_route_table_name = format("%s-private-rt", var.project_name)
}
