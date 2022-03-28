#resources
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-vpc"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.prefix}-ig"
  }
}

resource "aws_subnet" "subnet_public" {
  count                   = 2
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_subnet[count.index]
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone[count.index]
  tags = {
    Name = "${var.prefix}-subnet"
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.prefix}-rt"
  }

}

resource "aws_route_table_association" "rta_subnet_public" {
  count          = 2
  subnet_id      = aws_subnet.subnet_public[count.index].id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_security_group" "sg_22_80" {
  name   = "sg_22"
  vpc_id = aws_vpc.vpc.id

  # SSH access from the VPC
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

  tags = {
    Name = "${var.prefix}-securitygroup"
  }

}


resource "aws_security_group" "alb" {
  name        = "${var.prefix}-alb_security_group"
  description = "application load balancer security group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "private_key" {
  filename        = "${var.prefix}-key.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.prefix}-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "aws_instance" "application" {
  count                  = 2
  ami                    = data.aws_ami.amazon-linux-2.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_public[count.index].id
  vpc_security_group_ids = ["${aws_security_group.sg_22_80.id}"]
  key_name               = aws_key_pair.key_pair.key_name
  user_data              = file(var.user_data_file[count.index])


  provisioner "file" {
    source      = "./${aws_key_pair.key_pair.key_name}.pem"
    destination = "/home/ec2-user/${aws_key_pair.key_pair.key_name}.pem"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${aws_key_pair.key_pair.key_name}.pem")
      host        = self.public_ip
    }
  }
   tags = {
    Name = "${var.prefix}-instance"
  }

}
