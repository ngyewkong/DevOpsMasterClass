# configure ssh keygen ssh -f nameofSecretKey
// public key on aws ec2 private key on local or jumpbox
resource "aws_key_pair" "tf_aws_ssh_key" {
  key_name   = "tf_aws_ssh_key"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# Configure the Resources required (eg. ec2) search for ami id using https://cloud-images.ubuntu.com/locator/ec2/ 
resource "aws_instance" "ec2-ebs-created-by-tf" {
  ami               = lookup(var.AMI, var.AWS_REGION) # this will search for the AMI map and find the match with var.AWS_REGION
  instance_type     = "t2.micro"
  key_name          = aws_key_pair.tf_aws_ssh_key.key_name
  availability_zone = "us-east-2c"

  # tags = {Name = "name_of_instance"} used to update the instance Name in aws
  tags = {
    Name = "ec2-ebs-created-by-tf"
  }
  // security_groups = var.Security_Group -> outdated fields
}

# ebs resource (this will not delete on termination by default)
resource "aws_ebs_volume" "ebs-ec2-vol-1" {
  availability_zone = "us-east-2c"
  size              = 50    # in gb
  type              = "gp2" # type of storage (gp2, io1, etc)
  tags = {
    Name = "Secondary Volume Disk (GP2)"
  }
}

# attach ebs vol to the ec2 instance
resource "aws_volume_attachment" "ebs-ec2-volume-1-attachment" {
  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.ebs-ec2-vol-1.id
  instance_id = aws_instance.ec2-ebs-created-by-tf.id
}

# to check on the ebs configuration setup
# ssh into the ec2 --> change to root user (sudo -s) --> df -h
# will see the default ebs /dev/xvda1 but will not see the secondary ebs that we added in this file
# initially aws will attach a bare metal disk to the ec2 instance until you create a file system on the disk and mount that disk to your instance
# to create a filesystem on a linux disk
# execute mkfs.ext4 /dev/xvdh (Creating filesystem with 13107200 4k blocks and 3276800 inodes)
# mount that disk to the instance
# mkdir -p /data
# mount /dev/xvdh /data
# df -h (will see the /dev/xvdh ebs storage appearing and mounted to /data in this ec2 instance)
# however when we reboot the instance --> the mounted ebs will be gone
# vim /etc/fstab & add a new entry
# /dev/xvdh /data ext4 defaults 0 0
# reboot instance --> file and disk mounted will still remain
# terminate instance --> file & disk remains but will need to apply new mount to appear on the new ec2 instance
# note: there will be a timeout error for ebs volume attachment deletion as the ebs is still mounted to the ec2 instance 
# workaround unmount the disk or detach the ebs volume or terminate the ec2 instance first
