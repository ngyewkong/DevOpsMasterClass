terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# configure ssh keygen ssh -f nameofSecretKey
// public key on aws ec2 private key on local or jumpbox
resource "aws_key_pair" "aws_ssh_key" {
  key_name   = "aws_ssh_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# Configure the Resources required (eg. ec2) search for ami id using https://cloud-images.ubuntu.com/locator/ec2/ 
resource "aws_instance" "vm-created-using-terraform" {
  # count refers to the number of instances to be created
  count                  = var.INSTANCE_COUNT
  ami                    = lookup(var.AMI, var.AWS_REGION) # this will search for the AMI map and find the match with var.AWS_REGION
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.aws_ssh_key.key_name
  vpc_security_group_ids = var.Security_Group // use vpc_security_group_ids over security_groups 

  # tags = {Name = "name_of_instance"} used to update the instance Name in aws
  tags = {
    # will create the instances with terraform-demo-instances-0/1/2
    Name = "terraform-demo-instances-${count.index}"
  }


  # provisioner to get the InstallNginx.sh and make a copy at the AWS EC2 instance
  provisioner "file" {
    source      = "InstallNginx.sh"
    destination = "/tmp/InstallNginx.sh"
  }

  # provisioner to run commands
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/InstallNginx.sh",
      "sudo sed -i -e 's/\r$//' /tmp/InstallNginx.sh", # remove spurious cr characters (if file is created from windows)
      "sudo /tmp/InstallNginx.sh",
    ]
  }

  connection {
    host        = coalesce(self.public_ip, self.private_ip)
    type        = "ssh"
    user        = var.INSTANCE_NAME
    private_key = file(var.PATH_TO_PRIVATE_KEY)
  }

  // security_groups = var.Security_Group -> outdated fields
}
