#------------------------------------------------------------------------------
# Security Groups
#------------------------------------------------------------------------------

# Bastion Security Group - Allow SSH from anywhere
resource "aws_security_group" "bastion" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = module.app_vpc.vpc_id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.bastion_trusted_ips
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.envname_tags, {
    Name = "bastion-sg"
  })
}

# Test Instance Security Group - Allow SSH from bastion
resource "aws_security_group" "test_instance" {
  name        = "test-instance-sg"
  description = "Security group for test instance in private subnet"
  vpc_id      = module.app_vpc.vpc_id

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description = "ICMP from VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.app_vpc_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.envname_tags, {
    Name = "test-instance-sg"
  })
}

resource "aws_security_group" "vpc_endpoint_app_vpc" {
  name        = "vpc-endpoint-app-vpc-sg"
  description = "Security group for VPC endpoints in APP VPC"
  vpc_id      = module.app_vpc.vpc_id

  ingress {
    description = "Allow all inbound to HTTP proxy"
    from_port   = 1080
    to_port     = 1080
    protocol    = "tcp"
    cidr_blocks = [var.app_vpc_cidr]
  }

  ingress {
    description = "Allow all inbound to HTTPS proxy"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.app_vpc_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}