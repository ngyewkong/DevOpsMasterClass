# configure ssh keygen ssh -f nameofSecretKey
// public key on aws ec2 private key on local or jumpbox
resource "aws_key_pair" "tf_aws_ssh_key" {
  key_name   = "tf_aws_ssh_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# Configure the Resources required (eg. ec2) search for ami id using https://cloud-images.ubuntu.com/locator/ec2/ 
resource "aws_instance" "ec2-userdata-cloudinit-created-by-tf" {
  ami               = lookup(var.AMI, var.AWS_REGION) # this will search for the AMI map and find the match with var.AWS_REGION
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.tf_aws_ssh_key.key_name
  availability_zone = "us-east-2b"

  # set the user data to use cloud init config
  user_data = data.cloudinit_config.install_apache_config.rendered

  # tags = {Name = "name_of_instance"} used to update the instance Name in aws
  tags = {
    Name = "ec2-userdata-cloudinit-created-by-tf"
  }
  // security_groups = var.Security_Group -> outdated fields
}

# to output the public ip
output "public_ip" {
  value = aws_instance.ec2-userdata-cloudinit-created-by-tf.public_ip
}

# ssh into the ec2 instance
# systemctl status apache2 to check on the apache service
