#------------------------------------------------------------------------------
# Outputs
#------------------------------------------------------------------------------

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_public_dns" {
  description = "Public DNS of the bastion host"
  value       = aws_instance.bastion.public_dns
}

output "test_instance_private_ip" {
  description = "Private IP of the test instance"
  value       = aws_instance.test_instance.private_ip
}

output "ssh_command_bastion" {
  description = "SSH command to connect to bastion"
  value       = "ssh -i ~/.ssh/id_ed25519 ec2-user@${aws_instance.bastion.public_ip}"
}

output "ssh_command_test_instance" {
  description = "SSH command to connect to test instance via bastion"
  value       = "ssh -i ~/.ssh/id_ed25519 -J ec2-user@${aws_instance.bastion.public_ip} ec2-user@${aws_instance.test_instance.private_ip}"
}