## VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block            = "10.10.0.0/16"
  enable_dns_hostnames  = true
  enable_dns_support    = true

  tags = {
    Name = "LAB_VPC"
  }
}

## Subnet
resource "aws_subnet" "public-1a" {
  vpc_id                    = aws_vpc.demo_vpc.id
  cidr_block                = "10.10.10.0/24"
  availability_zone         = "us-east-1a"
  map_public_ip_on_launch   = true

  tags = {
    Name = "Public_Subnet_1a"
  }
}

## Route Table
resource "aws_route_table" "tf_rt_us_east_1a_public" {
    vpc_id = aws_vpc.demo_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.lab_igw.id
    }

    tags = {
        Name = "Public_Subnet_Route_Table"
    }
}

resource "aws_route_table_association" "tf_rt_assoc_us_east_1a_public" {
    subnet_id           = aws_subnet.public-1a.id
    route_table_id      = aws_route_table.tf_rt_us_east_1a_public.id
}

## Internet Gateway
resource "aws_internet_gateway" "lab_igw" {
  vpc_id = aws_vpc.demo_vpc.id

  tags = {
    Name = "tf_Internet_Gateway"
  }
}

## Security Group
resource "aws_security_group" "ssh_http" {
  name        = "allow_ssh_sg"
  description = "Allow SSH inbound connections"
  vpc_id = aws_vpc.demo_vpc.id

  ingress {
    description = "allow ssh traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "allow traffic from TCP/80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh-http_sg"
  }
}