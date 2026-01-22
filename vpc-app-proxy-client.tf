#------------------------------------------------------------------------------
# APPVPC - Application VPC
#------------------------------------------------------------------------------

module "app_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "v6.6.0"

  name = "app-proxy-client-vpc"
  cidr = var.app_vpc_cidr

  azs             = var.availability_zones
  public_subnets  = var.app_vpc_public_subnets
  private_subnets = var.app_vpc_private_subnets

  # No NAT Gateway - egress via Transit Gateway → EgressProxyVPC
  enable_nat_gateway = false

  # Enable Internet Gateway for public subnets (optional, for bastion hosts etc.)
  create_igw = true

  # Enable DNS support
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Subnet naming
  public_subnet_names  = ["app-proxy-client-vpc-public-a", "app-proxy-client-vpc-public-b", "app-proxy-client-vpc-public-c"]
  private_subnet_names = ["app-proxy-client-vpc-private-a", "app-proxy-client-vpc-private-b", "app-proxy-client-vpc-private-c"]

  # Tags
  tags = merge(local.envname_tags, {
    VPC = "APPVPC"
  })

  public_subnet_tags = {
    Type = "public"
    Tier = "application"
  }

  private_subnet_tags = {
    Type = "private"
    Tier = "application"
  }
}


