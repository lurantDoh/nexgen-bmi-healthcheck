terraform {
  backend "s3" {
    bucket         = "new-bmi-check-tfstate-027024089660"
    key            = "new-bmi-check/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "new-bmi-check-tf-locks"
    encrypt        = true
  }
}
