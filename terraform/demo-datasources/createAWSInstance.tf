terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# for fields known after terraform apply 
# can create datasource to retrieve the available AZs during run time
data "aws_availability_zones" "available" {}

# to find the available amis (go to aws console ec2 -> AMIs)
# terraform plan -var AWS_REGION="us-east-1" -> when variables.tf do not contain any related info for the amis
# will still able to find a matching ami
data "aws_ami" "latest-ubuntu" {
  most_recent = true
  owners      = ["099720109477"] // hardcode for ubuntu owner id
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] // find all ubuntu related images with wildcard char
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Configure the Resources required (eg. ec2) search for ami id using https://cloud-images.ubuntu.com/locator/ec2/ 
resource "aws_instance" "vm-created-using-terraform" {
  # count refers to the number of instances to be created
  count = var.INSTANCE_COUNT
  # ami                    = lookup(var.AMI, var.AWS_REGION) # this will search for the AMI map and find the match with var.AWS_REGION
  ami                    = data.aws_ami.latest-ubuntu.id // get the available image during runtime using datasource
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.Security_Group                             // use vpc_security_group_ids over security_groups 
  availability_zone      = data.aws_availability_zones.available.names[1] // choose the AZ at index 1 
  // when executing terraform plan -> available zone will now be populated with us-east-2b
  // if invalid eg data.aws_availability_zones.available.names[7] -> will error (is list of string with 3 elements)

  # tags = {Name = "name_of_instance"} used to update the instance Name in aws
  tags = {
    # will create the instances with terraform-demo-instances-0/1/2
    Name = "terraform-demo-instances-${count.index}"
  }

}
