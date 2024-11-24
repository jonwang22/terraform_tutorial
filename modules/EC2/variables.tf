variable instance_type{
    description     = "Default EC2 Instance to use."
    type            = string
    default         = "t2.micro"
} 

variable tf_vpc_id{
    description     = "VPC ID from VPC Module"
}

variable tf_public_subnet_id {}

variable tf_private_subnet_id {}