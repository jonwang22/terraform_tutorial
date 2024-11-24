# Creating our Custom VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block       = "10.0.0.0/20"
  instance_tenancy = "default"

  tags = {
    Name = "TF VPC"
  }
}

# Creating Public Subnet
resource "aws_subnet" "tf_public_subnet" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "TF Public Subnet"
  }
}

# Creating Private Subnet
resource "aws_subnet" "tf_private_subnet" {
  vpc_id     = aws_vpc.tf_vpc.id
  availability_zone = "us-east-1a"
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "TF Private Subnet"
  }
}

# Creating EIP for NAT Gateway
resource "aws_eip" "tf_nat_eip" {
  domain = "vpc"

  tags = {
    Name = "TF NAT EIP"
  }
}
# Creating NAT Gateway for Private subnet to use.
resource "aws_nat_gateway" "tf_nat_gateway" {
  allocation_id = aws_eip.tf_nat_eip.id
  subnet_id     = aws_subnet.tf_public_subnet.id

  tags = {
    Name = "TF NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.tf_igw]
}

# Creating Internet Gateway and associating the IGW to the Custom VPC via VPC ID
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "TF Internet Gateway"
  }
}

# Creating a custom Route Table for Public Subnet, assigning route for IGW
resource "aws_route_table" "tf_public_routetable" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "TF Public Route Table"
  }
}

# Creating a Private Route Table for Private Subnet
resource "aws_route_table" "tf_private_routetable" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tf_nat_gateway.id
  }

  tags = {
    Name = "TF Private Route Table"
  }
}

# Creating an association to Custom Public Subnet with Custom Public Route Table
resource "aws_route_table_association" "Public_Subnet_Association" {
  subnet_id      = aws_subnet.tf_public_subnet.id
  route_table_id = aws_route_table.tf_public_routetable.id
}

# Creating an association to Custom Private Subnet with Custom Private Route Table
resource "aws_route_table_association" "Private_Subnet_Association" {
  subnet_id      = aws_subnet.tf_private_subnet.id
  route_table_id = aws_route_table.tf_private_routetable.id
}