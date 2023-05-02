resource "aws_vpc" "jitsi_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "jitsi_public_subnet" {
  vpc_id            = aws_vpc.jitsi_vpc.id
  cidr_block        = "10.0.1.0/24"
  #availability_zone = "1a"

  tags = {
    Name = "Public Subnet"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.jitsi_vpc.id
  tags = {
    Name = "Internet Gateway"
  }
}
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.jitsi_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public Route Table"
  }
}
resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.jitsi_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}




resource "aws_security_group" "jitsi_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.jitsi_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}