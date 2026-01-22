#------------------------------------------------------------------------------
# EgressProxyVPC - Centralized egress VPC with NAT Gateways
#------------------------------------------------------------------------------

module "egress_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v6.6.0"

  name = "egress-proxy-vpc"
  cidr = var.egress_vpc_cidr

  azs             = var.availability_zones
  public_subnets  = var.egress_vpc_public_subnets
  private_subnets = var.egress_vpc_private_subnets

  # Enable NAT Gateway - single NAT Gateway for all subnets
  # https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/1269
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  # Enable Internet Gateway
  create_igw = true

  # Enable DNS support
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Subnet naming
  public_subnet_names  = ["egress-proxy-vpc-public-a", "egress-proxy-vpc-public-b", "egress-proxy-vpc-public-c"]
  private_subnet_names = ["egress-proxy-vpc-private-a", "egress-proxy-vpc-private-b", "egress-proxy-vpc-private-c"]

  # Tags
  tags = merge(local.envname_tags, {
    VPC = "EgressProxyVPC"
  })

  public_subnet_tags = {
    Type = "public"
  }

  private_subnet_tags = {
    Type = "private"
  }

  nat_gateway_tags = {
    Purpose = "egress-proxy"
  }
}
