// create the security grp using this values
// use datasource aws ip ranges and save it to us_east_ip_range
data "aws_ip_ranges" "us_east_ip_range" {
  regions  = ["us-east-1", "us-east-2"]
  services = ["ec2"]
}

// create the security group using resource keyword
// best practices: split the SG creation into two parts (creation of SG & creation of ingress/egress rules)
resource "aws_security_group" "custom-us-east-sg" {
  name        = "custom-us-east-sg"
  description = "custom SG that contains us-east-1 & us-east-2 regions"

  tags = {
    CreateDate = data.aws_ip_ranges.us_east_ip_range.create_date
    SyncToken  = data.aws_ip_ranges.us_east_ip_range.sync_token
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow-ssh" {
  // reference the SG to attach the rule
  security_group_id = aws_security_group.custom-us-east-sg.id
  // set the ingress rules (ports, protocol)
  // cidr_ipv4                    = "10.0.0.0/24" // this must be provided or referenced_security group_id
  referenced_security_group_id = aws_security_group.custom-us-east-sg.id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp" // set -1 for all protocols
}
