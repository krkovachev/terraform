provider "aws" {
    access_key = var.access_key
    secret_key = var.secret_key
    region = "eu-central-1"
}

resource "aws_vpc" "dof-vpc" {
    cidr_block = "10.10.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "DOF-VPC"
    }
}

resource "aws_internet_gateway" "dof-igw" {
  vpc_id = aws_vpc.dof-vpc.id
  tags = {
      Name = "DOF-IGW"
  }
}

resource "aws_route_table" "dof-prt" {
    vpc_id = aws_vpc.dof-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dof-igw.id
    }
    tags = {
        Name = "DOF-PUB_RT"
    }
}

resource "aws_subnet" "dof-snet" {
  vpc_id = aws_vpc.dof-vpc.id
  cidr_block = "10.10.10.0/24"
  map_public_ip_on_launch = true
  tags = {
      Name = "DOF-SUB-NET"
  }
}

resource "aws_route_table_association" "dof-prt-assoc" {
    subnet_id = aws_subnet.dof-snet.id
    route_table_id = aws_route_table.dof-prt.id
}

resource "aws_security_group" "dof-pub-sg" {
  name = "dof-pub-sg" 
  description = "DOF Public Security Group"
  vpc_id = aws_vpc.dof-vpc.id
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  } 
  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  } 
  egress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}

resource "aws_instance" "dof-server" {
    count = 2
    ami = "ami-06ec8443c2a35b0ba"
    instance_type= "t2.micro"
    key_name = "terraform-key"
    vpc_security_group_ids = [aws_security_group.dof-pub-sg.id]
    subnet_id = aws_subnet.dof-snet.id
    tags = {
      "Name" = "dof-server-${count.index + 1}"
    }
}

output "public_ip" {
    value = aws_instance.dof-server.*.public_ip
}