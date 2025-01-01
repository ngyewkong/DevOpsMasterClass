# leaving blank for AWS_ACCESS_KEY & AWS_SECRET_KEY will prompt in terminal for input during runtime
variable "AWS_ACCESS_KEY" {
  sensitive = true
}

variable "AWS_SECRET_KEY" {
  sensitive = true
}

variable "AWS_REGION" {
  default = "us-east-2"
}

// to generate the public & private keys need to use ssh-keygen
variable "PATH_TO_PRIVATE_KEY" {
  default   = "tf_aws_ssh_key"
  sensitive = true
}

variable "PATH_TO_PUBLIC_KEY" {
  default   = "tf_aws_ssh_key.pub"
  sensitive = true
}

variable "AMI" {
  type = map(string)
  default = {
    us-east-1 = "ami-0b0ea68c435eb488d"
    us-east-2 = "ami-05803413c51f242b7"
    us-west-1 = "ami-0454207e5367abf01"
    us-west-2 = "ami-0688ba7eeeeefe3cd"
  }
}
