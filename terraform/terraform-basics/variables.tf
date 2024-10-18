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
