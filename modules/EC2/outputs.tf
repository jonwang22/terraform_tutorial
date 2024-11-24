# Output block to display the public IP address of the created EC2 instance.
# Outputs are displayed at the end of the 'terraform apply' command and can be accessed using `terraform output`.
# They are useful for sharing information about your infrastructure that you may need later (e.g., IP addresses, DNS names).
output "jenkins_instance_ip" {
  value = aws_instance.jenkins.public_ip  # Display the public IP address of the EC2 instance after creation.
}
output "webserver_instance_ip" {
  value = aws_instance.webserver.public_ip  # Display the public IP address of the EC2 instance after creation.
}