provider "aws" {
  region = "us-west-2"
}

# resource "aws_vpc" "vpc" {
#   cidr_block = "10.0.0.0/16"
#   enable_dns_hostnames = true
  
#     tags = {
#     "Name" = "custom"
#   }
# }

# resource "aws_subnet" "private_subnet_2a" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "us-west-2a"

#   tags = {
#     "Name" = "private-subnet"
#   }
# }

# resource "aws_subnet" "private_subnet_2b" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "us-west-2b"

#   tags = {
#     "Name" = "private-subnet"
#   }
# }

# resource "aws_subnet" "private_subnet_2c" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.0.3.0/24"
#   availability_zone = "us-west-2c"

#   tags = {
#     "Name" = "private-subnet"
#   }
# }

# resource "aws_subnet" "public_subnet_2a" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.0.4.0/24"
#   availability_zone = "us-west-2a"

#   tags = {
#     "Name" = "public-subnet"
#   }
# }

# resource "aws_subnet" "public_subnet_2b" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.0.5.0/24"
#   availability_zone = "us-west-2b"

#   tags = {
#     "Name" = "public-subnet"
#   }
# }

# resource "aws_subnet" "public_subnet_2c" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.0.6.0/24"
#   availability_zone = "us-west-2c"

#   tags = {
#     "Name" = "public-subnet"
#   }
# }

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id 

  tags = {
    "Name" = "custom"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0" # định tuyến gateway subnet ra internet_gateway
    gateway_id = aws_internet_gateway.ig.id # resource internet_gateway
  }

  tags = {
    "Name" = "public"
  }
}

resource "aws_route_table_association" "assoc" {
  subnet_id = aws_subnet.public_subnet_2a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "public" {
  name = "allow_all"
  description = "Allow SSH"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  count = 2 
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet_2a.id
  associate_public_ip_address = true
  security_groups = [aws_security_group.public.id]
  key_name = aws_key_pair.sshkey.key_name #import key-public
}