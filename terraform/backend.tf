terraform {
  backend "s3" {
    bucket         = "nexgen-bmi-healthcheck-tfstate-027024089660"
    key            = "nexgen-bmi-healthcheck/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "nexgen-bmi-healthcheck-tf-locks"
    encrypt        = true
  }
}
