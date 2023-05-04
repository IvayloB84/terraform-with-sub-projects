provider "aws" {
  region = "us-west-2"
}

module "SNS" {
  source = "../modules/SNS"

  name        = "sub5-sns"
  dispay_name = "Terraform test module for SNS with Lambda function"
  dir         = "sub5-sns"
}