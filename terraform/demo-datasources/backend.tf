terraform {
  // set backend to s3
  // need to terraform init everything a backend is added
  // note to check on the aws credentials file (make sure temp token that are expired are deleted)
  // the tfstate file will be created with an etag
  // terminate the ec2 instance on console
  // terraform apply will recreate the ec2
  // the tfstate object in s3 -> will have 2 versions with the older version with the first etag created
  backend "s3" {
    // bucket -> bucket name that is created to hold tfstate files
    bucket = "tf-state-tutorial-bucket"
    // key is the path in the bucket (use to separate diff env tfstate files)
    key    = "dev/tf_state"
    region = "us-east-2"
  }
}
