
resource "aws_vpc" "terra_vpc" {
    cidr_block = "10.0.0.0/18"
    tags = {
        Name = "Terraform VPC"
    }
}

# Create public_subnet

resource "aws_subnet" "public_subnet" {
        vpc_id = aws_vpc.terra_vpc.id
        cidr_block = "10.0.0.0/24"
        map_public_ip_on_launch = "true"
        availability_zone =  "ap-south-1a"
        tags = {
            Name = "Public Subnet"
        }
}

# Create private_subnet

resource "aws_subnet" "private_subnet" {
        vpc_id = aws_vpc.terra_vpc.id
        cidr_block = "10.0.1.0/24"
        map_public_ip_on_launch = "false"
        availability_zone =  "ap-south-1a"
        tags = {
            Name = "private Subnet"
        }
}

# Create internet gateway

resource "aws_internet_gateway" "igw" {
        vpc_id = aws_vpc.terra_vpc.id
        tags = {
            Name = "Terraform IGW"
        }
}

# Create route table

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.terra_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    } 
    tags = {
        Name = "Public RT"
    }
}

# Create association b/w public subnet and pulic route table

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
  
}
