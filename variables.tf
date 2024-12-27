variable "region_name" {
  description = "The AWS region in which the VPC will be created"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "project_name" {
  description = "value of the 'Name' tag for the VPC"
    type        = string
}
variable "version_number" {
  description = "The version number of the VPC"
  type        = number
}
variable "public_subnet_cidr_block" {
  description = "The CIDR block for the public subnets"
  type        = list(string)
}
variable "availability_zones" {
  description = "The availability zones for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidr_block" {
    description = "The CIDR block for the private subnets"
    type        = list(string)

}
