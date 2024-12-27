variable "region_name" {
  description = "The name of the organization in Terraform Cloud"
  type        = string
}
variable "vpc_cidr_block" {}
variable "environment" {
  description = "The environment for the deployment"
  type        = string
}

variable "aws_tags" {
  description = "The base tags to apply to all AWS resources"
  type        = map(string)
  default     = {
    Owner   = "DevOps Team"
    Managed = "Terraform"
  }
}
# variable "subnents_cidr" {
#   description = "The CIDR block for the public subnet"
#   type = list(string)
# }
# # variable "private_cidr_block" {
# #     description = "The CIDR block for the private subnet"
# #     type = list(string)
# # }
# variable "availability_zones" {
#     description = "The availability zones to deploy the subnets"
#     type = list(string)
# }
variable "subnets" {
  description = "Map of subnet types (public/private) to lists of CIDR blocks"
  type        = map(list(string))
  default     = {
    public  = ["10.0.1.0/24", "10.0.2.0/24"]  # Public subnets
    private = ["10.0.3.0/24", "10.0.4.0/24"]  # Private subnets
  }
}

variable "availability_zones" {
  description = "The availability zones to deploy the subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
