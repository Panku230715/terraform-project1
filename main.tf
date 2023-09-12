#Create Security Groups

resource "aws_security_group" "security_group" {
  vpc_id = "${aws_vpc.terra_vpc.id}"
  name = "terraform_ec2_private_sg"

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
  }
  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 8080
    to_port = 8080
  }
  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
  }
  egress {
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
  }
  tags = {
    Name = "ec2-private-sg"
  }
}

output "aws_security_gr_id" {
  value = "${aws_security_group.security_group.id}"
}

#Create EC-2 in Public Subnet

resource "aws_instance" "Terra-Public" {
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ "${aws_security_group.security_group.id}" ]
    subnet_id = "${aws_subnet.public_subnet.id}"
    key_name = "Mynew-KP"
    count = 1
    associate_public_ip_address = true
    tags = {
      Name = "Terra-Public"
    }
}

#Create EC-2 in Private Subnet

resource "aws_instance" "Terra-Private" {
    ami = "ami-0f5ee92e2d63afc18"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ "${aws_security_group.security_group.id}" ]
    subnet_id = "${aws_subnet.private_subnet.id}"
    key_name = "Mynew-KP"
    count = 1
    associate_public_ip_address = false
    tags = {
      Name = "Terra-Private"
    }
}

