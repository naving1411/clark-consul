provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::991667272586:role/admin-role"
  }
}

terraform {
  backend "s3" {
    bucket = "clark-consul-test-navin"
    key    = "terraform.tfstate"
    region = "us-west-2"
    profile = "in-main-terraform"
    role_arn = "arn:aws:iam::991667272586:role/admin-role"
  }
}
