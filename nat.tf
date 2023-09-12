# Create Elastic IP

resource "aws_eip" "nat_eip" {
    vpc = true
    depends_on = [ aws_internet_gateway.igw ]
    tags = {
        Name = "NAT EIP"
    }
}

# Create NAT gateway

resource "aws_nat_gateway" "nat" {
    allocation_id =  aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnet.id

    tags = {
      Name = "Terraform NAT Gateway"
    }
}

# Create route table

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.terra_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat.id
    } 
    tags = {
        Name = "Private RT"
    }
}

# Create association b/w private subnet and private route table

resource "aws_route_table_association" "private" {
    subnet_id = aws_subnet.private_subnet.id
    route_table_id = aws_route_table.private_rt.id
  
}