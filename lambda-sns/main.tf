provider "aws" {
  region = "us-west-2"   
}

data "aws_caller_identity" "current" {}

resource "aws_sns_topic" "user_updates" {
  name = "tf-sns-topic"
}

