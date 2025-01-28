provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "k8s_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "${var.aws_region}a"
  tags = {
    Name = "${var.cluster_name}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.aws_region}b"
  tags = {
    Name = "${var.cluster_name}-private-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.k8s_vpc.id
  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.k8s_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.cluster_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "k8s_master_sg" {
  vpc_id = aws_vpc.k8s_vpc.id

  ingress {
    from_port   = 6443
    to_port     = 6443
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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-master-sg"
  }
}

resource "aws_security_group" "k8s_node_sg" {
  vpc_id = aws_vpc.k8s_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-node-sg"
  }
}

resource "aws_instance" "k8s_master" {
  ami           = "ami-0039af0a1686c51a9" # Replace with a valid AMI ID for your region
  instance_type = var.master_instance_type
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = var.ssh_key_name

  vpc_security_group_ids = [aws_security_group.k8s_master_sg.id]

  tags = {
    Name = "${var.cluster_name}-master"
  }
}

resource "aws_instance" "k8s_node" {
  count         = var.node_count
  ami           = "ami-0039af0a1686c51a9" # Replace with a valid AMI ID for your region
  instance_type = var.node_instance_type
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = var.ssh_key_name

  vpc_security_group_ids = [aws_security_group.k8s_node_sg.id]

  tags = {
    Name = "${var.cluster_name}-node-${count.index}"
  }
}