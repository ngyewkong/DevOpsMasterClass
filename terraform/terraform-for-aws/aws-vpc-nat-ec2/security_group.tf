# create security group that will use the vpc that we created
resource "aws_security_group" "vpc_allow_ssh" {
  vpc_id      = aws_vpc.tf_created_vpc.id
  name        = "vpc_allow_ssh"
  description = "security group that allows ssh connection"

  # egress rule - for outbound traffic
  # to check if egress to all public internet is configured properly
  # execute sudo -s (change to root user)
  # sudo apt-get update (this should update as internet access shld not be denied)
  # apt-get install wget curl
  # try to curl google.com (execute curl https://www.google.com)
  egress {
    from_port   = 0             # all ports
    to_port     = 0             # all ports
    protocol    = "-1"          # all protocols
    cidr_blocks = ["0.0.0.0/0"] # all ip will be allowed from your machines in the security grp
  }

  # ingress rule - for inbound traffic
  # to try to access the ec2 instance --> execute ssh ec2_Public_IP -l ubuntu -i ssh_key
  ingress {
    from_port   = 22            # port 22
    to_port     = 22            # port 22
    protocol    = "tcp"         # allowed protocol
    cidr_blocks = ["0.0.0.0/0"] # allow incoming traffic from all ips to the machines (not best practices)
  }

  tags = {
    Name = "vpc_allow_ssh"
  }
}
