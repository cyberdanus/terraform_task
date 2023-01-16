resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  instance_tenancy = "default"

  tags = {
    Name = "VPC"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.public}"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.private}"
  }
}

resource "aws_subnet" "database" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.az}"

  tags = {
    Name = "${var.database}"
  }
}

resource "aws_internet_gateway" "prod-igw" {
    vpc_id = aws_vpc.main.id

    tags = {
    Name = "IGW"
  }
}


resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id         = aws_subnet.public.id

  tags = {
    Name = "NGW"
  }
}

resource "aws_eip" "example" {
  vpc = true

  tags = {
    Name = "NAT-EIP"
  }
}

resource "aws_route_table" "prod-public" {
    vpc_id = aws_vpc.main.id
    
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.prod-igw.id
    }
      tags = {
    Name = "${var.public}-RT"
  }
}

resource "aws_route_table_association" "public-subnet"{
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.prod-public.id
}

resource "aws_route_table" "prod-private" {
    vpc_id = aws_vpc.main.id
    
    route {
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_nat_gateway.example.id
    }
      tags = {
    Name = "${var.private}-RT"
  }
}

resource "aws_route_table_association" "private-subnet"{
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.prod-private.id
}

resource "aws_route_table" "prod-database" {
    vpc_id = aws_vpc.main.id
    
      tags = {
    Name = "${var.database}-RT"
  }
}

resource "aws_route_table_association" "database-subnet"{
    subnet_id = aws_subnet.database.id
    route_table_id = aws_route_table.prod-database.id
}
