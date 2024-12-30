# configure ssh keygen ssh -f nameofSecretKey
// public key on aws ec2 private key on local or jumpbox
resource "aws_key_pair" "tf_aws_ssh_key" {
  key_name   = "tf_aws_ssh_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# Configure the Resources required (eg. ec2) search for ami id using https://cloud-images.ubuntu.com/locator/ec2/ 
resource "aws_instance" "ec2-created-tf-with-vpc" {
  # count refers to the number of instances to be created
  count                  = var.INSTANCE_COUNT
  ami                    = lookup(var.AMI, var.AWS_REGION) # this will search for the AMI map and find the match with var.AWS_REGION
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.tf_aws_ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.vpc_allow_ssh.id]        # use vpc_security_group_ids over security_groups 
  subnet_id              = aws_subnet.tf_created_vpc_public_subnet-2.id # set the subnet to spin up the ec2 instances in

  # tags = {Name = "name_of_instance"} used to update the instance Name in aws
  tags = {
    Name = "tf-ec2-with-vpc"
  }
  // security_groups = var.Security_Group -> outdated fields
}
