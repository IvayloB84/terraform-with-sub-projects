provider "aws" {
  region = "us-west-2"
}

module "sns" {
  source = "../modules/SNS"

  name        = "sub5-sns"
  dispay_name = "TF-topic"
  dir         = "sub5-sns"
}