terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the Resources required (eg. ec2) search for ami id using https://cloud-images.ubuntu.com/locator/ec2/ 
resource "aws_instance" "vm-created-using-terraform" {
  # count refers to the number of instances to be created
  count         = 3
  ami           = "ami-05803413c51f242b7"
  instance_type = "t2.micro"

  # tags = {Name = "name_of_instance"} used to update the instance Name in aws
  tags = {
    # will create the instances with terraform-demo-instances-0/1/2
    Name = "terraform-demo-instances-${count.index}"
  }
}
