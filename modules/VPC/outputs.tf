# Output block to display the public IP address of the created EC2 instance.
# Outputs are displayed at the end of the 'terraform apply' command and can be accessed using `terraform output`.
# They are useful for sharing information about your infrastructure that you may need later (e.g., IP addresses, DNS names).
output "tf_vpc_id" {
  value = aws_vpc.tf_vpc.id  # Display the VPC ID.
}
output "tf_public_subnet_id" {
  value = aws_subnet.tf_public_subnet.id  # Display public subnet ID.
}
output "tf_private_subnet_id" {
  value = aws_subnet.tf_private_subnet.id  # Display public subnet ID.
}