terraform {
  backend "s3" {
    bucket = "terraform-backend-c59-bucket"
    key    = "terraform.tfstate"
    region = "us-west-1"
  }
}
provider "aws" {
  region = var.region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_cidr
  availability_zone = var.az1
  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.public_cidr
  availability_zone = var.az2
  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "${var.project_name}-IGW"
  }
}

resource "aws_default_route_table" "main_RT" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id
  tags = {
    Name = "${var.project_name}-main-RT"
  }
}

resource "aws_route" "aws_route" {
  route_table_id         = aws_default_route_table.main_RT.id
  destination_cidr_block = var.igw_cidr
  gateway_id             = aws_internet_gateway.my_igw.id
}

resource "aws_security_group" "my_sg" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = "${var.project_name}-SG"
  description = "allow ssh, http, mysql traffic"

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public_server" {
  subnet_id              = aws_subnet.public_subnet.id
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "terraform"
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "${var.project_name}-public-server"
  }
}

resource "aws_instance" "private_server" {
  subnet_id              = aws_subnet.private_subnet.id
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = "terraform"
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "${var.project_name}-db-server"
  }
}