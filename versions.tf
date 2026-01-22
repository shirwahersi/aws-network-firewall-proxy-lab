terraform {
  required_version = "~> 1.14.3"

  required_providers {
    # Provider Documentation: https://registry.terraform.io/providers/hashicorp/aws/latest
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.28.0"
    }
  }
}
