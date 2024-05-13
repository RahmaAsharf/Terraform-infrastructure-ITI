terraform {
  backend "s3" {
    bucket         = "terraform-tfstate-iti44"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
  }
}
