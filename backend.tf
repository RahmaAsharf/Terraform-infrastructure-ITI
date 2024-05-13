terraform {
  backend "s3" {
    bucket         = "terraform-rahmalab2"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "state-lock"
  }
}
