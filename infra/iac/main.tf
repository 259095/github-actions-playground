

module "vpc-configuration" {
  source = "./terraform-aws-vpc-configuration"

  cidr                                = var.cidr
}

module "vpc" {
  source = "./terraform-aws-vpc"

  name                                = "${var.name}-dev"

  cidr                                = var.cidr
  azs                                 = module.vpc-configuration.azs_names
  private_subnets                     = module.vpc-configuration.private_subnets
  public_subnets                      = module.vpc-configuration.public_subnets

  enable_nat_gateway                  = var.enable_nat_gateway
  single_nat_gateway                  = var.single_nat_gateway
  enable_vpn_gateway                  = var.enable_vpn_gateway
  enable_dns_hostnames                = var.enable_dns_hostnames

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.name}-dev" = "shared"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.name}-dev" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }

}

# TBD replace below resource with a module
resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

module "eks" {
  source = "./terraform-aws-eks"

  cluster_name                        = "${var.name}-dev"
  cluster_version                     = "1.17"
  
  subnets                             = module.vpc.private_subnets
  vpc_id                              = module.vpc.vpc_id

  worker_groups = [
    {
      name                            = "worker-group-1"
      instance_type                   = "t2.medium"
      asg_desired_capacity            = 2
    }
  ]

  worker_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  map_roles                            = var.map_roles
  map_users                            = var.map_users
  map_accounts                         = var.map_accounts
}