resource "aws_vpc" "kc-vpc-sergi" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "kc-vpc-sergi"
  }
}

resource "aws_subnet" "kc-subnet-sergi-1" {
  vpc_id                  = aws_vpc.kc-vpc-sergi.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "kc-subnet-sergi-1"
    Description = "Subred para el servicio kc-sergi en la zona eu-west-1a"
  }
}

resource "aws_subnet" "kc-subnet-sergi-2" {
  vpc_id                  = aws_vpc.kc-vpc-sergi.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true
  tags = {
    Name        = "kc-subnet-sergi-2"
    Description = "Subred para el servicio kc-sergi en la zona eu-west-1b"
  }
}

resource "aws_internet_gateway" "kc-igw-sergi" {
  vpc_id = aws_vpc.kc-vpc-sergi.id
}

resource "aws_route" "kc-public-route-sergi" {
  route_table_id         = aws_vpc.kc-vpc-sergi.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.kc-igw-sergi.id
}

resource "aws_security_group" "kc-nginx-sergi" {
  name        = "kc-nginx-sergi"
  description = "Allow SSH and HTTP inbound traffic"

  vpc_id = aws_vpc.kc-vpc-sergi.id

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
