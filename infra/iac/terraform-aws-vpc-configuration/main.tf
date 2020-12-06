data "aws_availability_zones" "available" {
  state = "available"
}

locals {
    private_subnet_start = 1
    public_subnet_start = 101
}

data "null_data_source" "private_subnets" {
  count = length(data.aws_availability_zones.available.names)
  inputs = {
  outputs = cidrsubnet(var.cidr,8,count.index+local.private_subnet_start)
  }
}

data "null_data_source" "public_subnets" {
  count = length(data.aws_availability_zones.available.names)
  inputs = {
  outputs = cidrsubnet(var.cidr,8,count.index+local.public_subnet_start)
  }
}