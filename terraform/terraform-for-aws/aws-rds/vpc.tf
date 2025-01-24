# create aws virtual private cloud (vpc)
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "tf_created_vpc" {
  // The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using ipv4_netmask_length.
  cidr_block = "10.0.0.0/16"
  // A tenancy option for instances launched into the VPC. Default is default, which ensures that EC2 instances launched in this VPC use the EC2 instance tenancy attribute specified when the EC2 instance is launched. 
  // The only other option is dedicated, which ensures that EC2 instances launched in this VPC are run on dedicated tenancy instances regardless of the tenancy attribute specified at launch. This has a dedicated per region fee of $2 per hour, plus an hourly per instance usage fee.
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "tf_created_vpc"
  }
}

# create public subnets in custom vpc
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
resource "aws_subnet" "tf_created_vpc_public_subnet-1" {
  vpc_id     = aws_vpc.tf_created_vpc.id
  cidr_block = "10.0.1.0/24"
  // (Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2a"
}

# create two more subnets in us-east-2b & 2c AZs
resource "aws_subnet" "tf_created_vpc_public_subnet-2" {
  vpc_id     = aws_vpc.tf_created_vpc.id
  cidr_block = "10.0.2.0/24" // cannot overlap cidr ipranges
  // (Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2b"
}

resource "aws_subnet" "tf_created_vpc_public_subnet-3" {
  vpc_id     = aws_vpc.tf_created_vpc.id
  cidr_block = "10.0.3.0/24"
  // (Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-2c"
}

# create private subnets in custom vpc
resource "aws_subnet" "tf_created_vpc_private_subnet-1" {
  vpc_id     = aws_vpc.tf_created_vpc.id
  cidr_block = "10.0.4.0/24" // cannot overlap cidr ipranges
  // specify false to make the subnet private
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2a"
}

# create two more subnets in us-east-2b & 2c AZs
resource "aws_subnet" "tf_created_vpc_private_subnet-2" {
  vpc_id                  = aws_vpc.tf_created_vpc.id
  cidr_block              = "10.0.5.0/24" // cannot overlap cidr ipranges
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2b"
}

resource "aws_subnet" "tf_created_vpc_private_subnet-3" {
  vpc_id                  = aws_vpc.tf_created_vpc.id
  cidr_block              = "10.0.6.0/24" // cannot overlap cidr ipranges
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-2c"
}

# create internet gateway
resource "aws_internet_gateway" "tf_created_gw" {
  vpc_id = aws_vpc.tf_created_vpc.id

  tags = {
    Name = "tf_created_gw"
  }

}

# create routing table for the VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "tf_created_rt" {
  vpc_id = aws_vpc.tf_created_vpc.id

  tags = {
    Name = "tf_created_vpc_public-1"
  }
}

# terraform current version need to have a route resource separate from route table
resource "aws_route" "tf_created_public_route" {
  route_table_id         = aws_route_table.tf_created_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tf_created_gw.id
}

# routing association
resource "aws_route_table_association" "tf_created_ra-public-1-a" {
  subnet_id      = aws_subnet.tf_created_vpc_public_subnet-1.id
  route_table_id = aws_route_table.tf_created_rt.id
}

resource "aws_route_table_association" "tf_created_ra-public-2-a" {
  subnet_id      = aws_subnet.tf_created_vpc_public_subnet-2.id
  route_table_id = aws_route_table.tf_created_rt.id
}

resource "aws_route_table_association" "tf_created_ra-public-3-a" {
  subnet_id      = aws_subnet.tf_created_vpc_public_subnet-3.id
  route_table_id = aws_route_table.tf_created_rt.id
}
