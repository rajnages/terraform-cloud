locals {
  common_tags = merge(var.aws_tags, { Environment = var.environment })
}
