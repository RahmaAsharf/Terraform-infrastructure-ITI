vpc_cidr  = "10.0.0.0/16"
tag       = "terraform2-prod"
region    = "eu-central-1"
cidr_zero = "0.0.0.0/0"

machine_details = {
  type      = "t2.micro"
  ami       = "ami-09e67e426f25ce0d7"
  public_ip = true
}

subnets_details = [

  {
    name = "public1",
    cidr = "10.0.1.0/24",
    type = "public"
  },

  {
    name = "private1",
    cidr = "10.0.2.0/24",
    type = "private"
  }

]

db_pass = "12345ra12345"