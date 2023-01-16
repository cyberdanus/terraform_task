provider "aws" {
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.49"
    }
  }
}

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
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private"
  }
}

resource "aws_subnet" "database" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "database"
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
    Name = "public-RT"
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
    Name = "private-RT"
  }
}

resource "aws_route_table_association" "private-subnet"{
    subnet_id = aws_subnet.private.id
    route_table_id = aws_route_table.prod-private.id
}

resource "aws_route_table" "prod-database" {
    vpc_id = aws_vpc.main.id
    
      tags = {
    Name = "database-RT"
  }
}

resource "aws_route_table_association" "database-subnet"{
    subnet_id = aws_subnet.database.id
    route_table_id = aws_route_table.prod-database.id
}


resource "aws_security_group" "bastion" {
    vpc_id = aws_vpc.main.id
    name = "SG-Bastion"
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/24","10.0.1.0/24","82.209.240.102/32"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
      tags = {
    Name = "SG-Bastion"
  }
}

resource "aws_security_group" "public" {
    vpc_id = aws_vpc.main.id
    name = "SG-Public"
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.0.1.0/24"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
        ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
      tags = {
    Name = "SG-Public"
  }
}

resource "aws_security_group" "private" {
    vpc_id = aws_vpc.main.id
    name = "SG-Private"
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/24","10.0.2.0/24"]
    }
        ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
      tags = {
    Name = "SG-Private"
  }
}

resource "aws_security_group" "database" {
    vpc_id = aws_vpc.main.id
    name = "SG-Database"
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["10.0.2.0/24"]
    }
        ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
      tags = {
    Name = "SG-Database"
  }
}


data "aws_ami" "ami_latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] 
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ami_latest.id
  instance_type = "t2.micro"
  key_name = "keypair"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  tags = {
    Name = "Bastion"
  }
}

resource "aws_instance" "web2" {
  ami           = data.aws_ami.ami_latest.id
  instance_type = "t2.micro"
  key_name = "keypair"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public.id]
  associate_public_ip_address = true

  tags = {
    Name = "Public-ec2"
  }
}
resource "aws_instance" "web3" {
  ami           = data.aws_ami.ami_latest.id
  instance_type = "t2.micro"
  key_name = "keypair"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.private.id]

  tags = {
    Name = "Private-ec2"
  }
}
resource "aws_instance" "web4" {
  ami           = data.aws_ami.ami_latest.id
  instance_type = "t2.micro"
  key_name = "keypair"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.database.id]

  tags = {
    Name = "Database"
  }
}