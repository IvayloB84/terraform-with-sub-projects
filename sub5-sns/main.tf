## Default AZ (Availability Zone) for the resources
provider "aws" {
  region = "us-west-2"
}

## SNS base configuration
module "sns" {
  source = "../modules/sns"
                           
  name        = "sub5-sns"
  dispay_name = "TF-topic"
  dir         = "sub5-sns"
} 