output "vpc_id" {
  value = aws_vpc.terraform_vpc.id
}

output "public_subnet_ids" {
  value = [for subnet in aws_subnet.all_subnets : subnet.id if subnet.tags["Type"] == "public"]
}
