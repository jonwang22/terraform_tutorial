# Local variables are only used within the scope of the current configuration file where they are defined.
# They are not passed between modules or configurations. 
locals {
  jenkins_tag = "jenkins_tf_made"
  web_tag = "webserver_tf_made"
  app_tag = "appserver_tf_made"
}

# Create an EC2 instance in AWS. This resource block defines the configuration of the instance.
# This EC2 is created in our Public Subnet
resource "aws_instance" "jenkins" {
  ami               = "ami-0866a3c8686eaeeba"                # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
  instance_type     = var.instance_type                # Specify the desired EC2 instance size.
  subnet_id         = var.tf_public_subnet_id
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids = [aws_security_group.tf_jenkins_sg.id]         # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "jonprimarykey"                # The key pair name for SSH access to the instance.
  user_data         = "${file("install_jenkins.sh")}"
  
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : local.jenkins_tag
  }
}

# Create a security group named "tf_made_sg" that allows SSH and HTTP traffic.
# This security group will be associated with the EC2 instance created above.
# This is Security Group for Jenkins
resource "aws_security_group" "tf_jenkins_sg" { # aws_security_group is the actual AWS resource name. web_ssh is the name stored by Terraform locally for record keeping 
  vpc_id      = var.tf_vpc_id
  name        = "tf_jenkins_sg"
  description = "open ssh traffic"
  # Ingress rules: Define inbound traffic that is allowed.Allow SSH traffic and HTTP traffic on port 8080 from any IP address (use with caution)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Egress rules: Define outbound traffic that is allowed. The below configuration allows all outbound traffic from the instance.
  egress {
    from_port   = 0                                     # Allow all outbound traffic (from port 0 to any port)
    to_port     = 0
    protocol    = "-1"                                  # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]                         # Allow traffic to any IP address
  }
  # Tags for the security group
  tags = {
    "Name"      : "tf_jenkins_sg"                          # Name tag for the security group
    "Terraform" : "true"                                # Custom tag to indicate this SG was created with Terraform
  }
}

# Create an EC2 instance in AWS. This resource block defines the configuration of the instance.
# This EC2 is created in our Public Subnet
resource "aws_instance" "webserver" {
  ami               = "ami-0866a3c8686eaeeba"                # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
  instance_type     = var.instance_type                # Specify the desired EC2 instance size.
  subnet_id         = var.tf_public_subnet_id
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids = [aws_security_group.tf_web_sg.id]         # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "jonprimarykey"                # The key pair name for SSH access to the instance.
  
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : local.web_tag
  }
}

# Create a security group named "tf_made_sg" that allows SSH and HTTP traffic.
# This security group will be associated with the EC2 instance created above.
# This is Security Group for Jenkins
resource "aws_security_group" "tf_web_sg" { # aws_security_group is the actual AWS resource name. web_ssh is the name stored by Terraform locally for record keeping 
  vpc_id      = var.tf_vpc_id
  name        = "tf_web_sg"
  description = "open ssh traffic"
  # Ingress rules: Define inbound traffic that is allowed.Allow SSH traffic and HTTP traffic on port 8080 from any IP address (use with caution)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Egress rules: Define outbound traffic that is allowed. The below configuration allows all outbound traffic from the instance.
  egress {
    from_port   = 0                                     # Allow all outbound traffic (from port 0 to any port)
    to_port     = 0
    protocol    = "-1"                                  # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]                         # Allow traffic to any IP address
  }
  # Tags for the security group
  tags = {
    "Name"      : "tf_web_sg"                          # Name tag for the security group
    "Terraform" : "true"                                # Custom tag to indicate this SG was created with Terraform
  }
}

# Create an EC2 instance in AWS. This resource block defines the configuration of the instance.
# This EC2 is created in our Public Subnet
resource "aws_instance" "appserver" {
  ami               = "ami-0866a3c8686eaeeba"                # The Amazon Machine Image (AMI) ID used to launch the EC2 instance.
  instance_type     = var.instance_type                # Specify the desired EC2 instance size.
  subnet_id         = var.tf_private_subnet_id
  # Attach an existing security group to the instance.
  # Security groups control the inbound and outbound traffic to your EC2 instance.
  vpc_security_group_ids = [aws_security_group.tf_app_sg.id]         # Replace with the security group ID, e.g., "sg-01297adb7229b5f08".
  key_name          = "jonprimarykey"                # The key pair name for SSH access to the instance.
  
  # Tagging the resource with a Name label. Tags help in identifying and organizing resources in AWS.
  tags = {
    "Name" : local.app_tag
  }
}

# Create a security group named "tf_made_sg" that allows SSH and HTTP traffic.
# This security group will be associated with the EC2 instance created above.
# This is Security Group for Jenkins
resource "aws_security_group" "tf_app_sg" { # aws_security_group is the actual AWS resource name. web_ssh is the name stored by Terraform locally for record keeping 
  vpc_id      = var.tf_vpc_id
  name        = "tf_app_sg"
  description = "open ssh traffic"
  # Ingress rules: Define inbound traffic that is allowed.Allow SSH traffic and HTTP traffic on port 8080 from any IP address (use with caution)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    ="tcp"
    cidr_blocks = ["10.0.0.0/24"]
  }
  # Egress rules: Define outbound traffic that is allowed. The below configuration allows all outbound traffic from the instance.
  egress {
    from_port   = 0                                     # Allow all outbound traffic (from port 0 to any port)
    to_port     = 0
    protocol    = "-1"                                  # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]                         # Allow traffic to any IP address
  }
  # Tags for the security group
  tags = {
    "Name"      : "tf_app_sg"                          # Name tag for the security group
    "Terraform" : "true"                                # Custom tag to indicate this SG was created with Terraform
  }
}