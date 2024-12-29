# Define the external IP
resource "aws_eip" "tf_created_nat" {
  domain = "vpc"
}

# setup the nat gateway using the external ip 
resource "aws_nat_gateway" "tf_created_nat_gw" {
  allocation_id = aws_eip.tf_created_nat.id
  subnet_id     = aws_subnet.tf_created_vpc_public_subnet-1.id
  depends_on    = [aws_internet_gateway.tf_created_gw]
}

# setup the vpc for the nat gw --> so that the outside machine cannot access this ec2
# reverse traffic from public internet cannot access the ec2
resource "aws_route_table" "tf_created_rt_private" {
  vpc_id = aws_vpc.tf_created_vpc.id

  tags = {
    Name = "tf_created_vpc_private-1"
  }
}

# setup route resource for private route
resource "aws_route" "tf_created_private_route" {
  route_table_id         = aws_route_table.tf_created_rt_private.id
  nat_gateway_id         = aws_nat_gateway.tf_created_nat_gw.id
  destination_cidr_block = "0.0.0.0/0"
}

# setup the route table association for the three private subnets
resource "aws_route_table_association" "tf_created_ra-private-1-a" {
  subnet_id      = aws_subnet.tf_created_vpc_private_subnet-1.id
  route_table_id = aws_route_table.tf_created_rt_private.id
}

resource "aws_route_table_association" "tf_created_ra-private-2-a" {
  subnet_id      = aws_subnet.tf_created_vpc_private_subnet-2.id
  route_table_id = aws_route_table.tf_created_rt_private.id
}
resource "aws_route_table_association" "tf_created_ra-private-3-a" {
  subnet_id      = aws_subnet.tf_created_vpc_private_subnet-3.id
  route_table_id = aws_route_table.tf_created_rt_private.id
}
