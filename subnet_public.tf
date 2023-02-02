resource "aws_subnet" "public_subnet_2a" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    "Name" = "public-subnet"
  }
}
