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
  ami           = "ami-05803413c51f242b7"
  instance_type = "t2.micro"
}
