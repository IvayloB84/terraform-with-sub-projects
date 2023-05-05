## Default AZ (Availability Zone) for the resources
provider "aws" {
  region = "us-west-2"
}

## SNS basic configuration with name and display name.
module "sns" {
  source = "../modules/sns"
                           
  some_name        = "sub5-sns"
//  dispay_name = "TF-topic"
//  dir         = "sub5-sns"
} 