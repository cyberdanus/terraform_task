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
  instance_type = "${var.instance_type}"
  key_name = "${var.keypair}"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  tags = {
    Name = "Bastion"
  }
}

resource "aws_instance" "web2" {
  ami           = data.aws_ami.ami_latest.id
  instance_type = "${var.instance_type}"
  key_name = "${var.keypair}"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public.id]
  associate_public_ip_address = true

  tags = {
    Name = "Public-ec2"
  }
}
resource "aws_instance" "web3" {
  ami           = data.aws_ami.ami_latest.id
  instance_type = "${var.instance_type}"
  key_name = "${var.keypair}"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.private.id]

  tags = {
    Name = "Private-ec2"
  }
}
resource "aws_instance" "web4" {
  ami           = data.aws_ami.ami_latest.id
  instance_type = "${var.instance_type}"
  key_name = "${var.keypair}"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.database.id]

  tags = {
    Name = "Database"
  }
}
