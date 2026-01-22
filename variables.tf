variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-2"
}

variable "availability_zones" {
  description = "Availability zones for deployment"
  type        = list(string)
  default     = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

# EgressProxyVPC CIDR Configuration
variable "egress_vpc_cidr" {
  description = "CIDR block for EgressProxyVPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "egress_vpc_public_subnets" {
  description = "Public subnet CIDRs for EgressProxyVPC (NAT Gateways)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "egress_vpc_private_subnets" {
  description = "Private subnet CIDRs for EgressProxyVPC (TGW attachment)"
  type        = list(string)
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# # APPVPC CIDR Configuration
variable "app_vpc_cidr" {
  description = "CIDR block for APPVPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "app_vpc_public_subnets" {
  description = "Public subnet CIDRs for APPVPC"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
}

variable "app_vpc_private_subnets" {
  description = "Private subnet CIDRs for APPVPC"
  type        = list(string)
  default     = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
}

variable "bastion_trusted_ips" {
  description = "List of trusted IP addresses"
  type        = list(string)
}