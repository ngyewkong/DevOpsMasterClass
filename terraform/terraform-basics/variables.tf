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

variable "INSTANCE_COUNT" {
  default = 3
}

variable "Security_Group" {
  type = list(string)
  # default = ["sg-24076", "sg-90890", "sg-12345"]
  default = ["sg-0c7de8c9df43291a2"]
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

variable "INSTANCE_NAME" {
  default = "ubuntu"
}

// to generate the public & private keys need to use ssh-keygen
variable "PATH_TO_PRIVATE_KEY" {
  default = "aws_ssh_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "aws_ssh_key.pub"
}
