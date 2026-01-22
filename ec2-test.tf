#------------------------------------------------------------------------------
# EC2 Instances for Testing Connectivity
#------------------------------------------------------------------------------

# Get the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#------------------------------------------------------------------------------
# SSH Key Pair
#------------------------------------------------------------------------------

resource "aws_key_pair" "bastion" {
  key_name   = "${local.resource_name_prefix}-bastion-key"
  public_key = trimspace(file(pathexpand("~/.ssh/id_ed25519.pub")))

  tags = merge(local.envname_tags, {
    Name = "${local.resource_name_prefix}-bastion-key"
  })
}

#------------------------------------------------------------------------------
# EC2 Instances
#------------------------------------------------------------------------------

# Bastion Host in public subnet
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.bastion.key_name
  subnet_id                   = module.app_vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = merge(local.envname_tags, {
    Name = "${local.resource_name_prefix}-bastion"
  })
}

# Test Instance in private subnet
resource "aws_instance" "test_instance" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.bastion.key_name
  subnet_id              = module.app_vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.test_instance.id]

  tags = merge(local.envname_tags, {
    Name = "${local.resource_name_prefix}-test-instance"
  })
}
