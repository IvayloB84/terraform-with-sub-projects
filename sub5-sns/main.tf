data "aws_caller_identity" "current" {}

## Default AZ (Availability Zone) for the resources
provider "aws" {
  region = "us-west-2"
}

resource "aws_sns_topic" "tf-sns-topic" {
  name = "tf-sns-topic"
}