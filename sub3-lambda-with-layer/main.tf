provider "aws" {
  region = "us-west-2"
}

module "lambda" {
   source = "./modules"
}

locals {
   vpc_id = "${modules.my_vpc.vpc_id}"
}


resource "time_sleep" "wait_20_seconds" {

  create_duration = "20s"
}

module "lambda-layer" {
  source = "../modules/lambda/lambda-layer"

  layer_name =  "sub3-lambda-with-layer"
  function_name       = "tf-lambda-sub3"
  description         = "Lambda function + layer created with Terraform"

  create_layer = true

  depends_on = [ time_sleep.wait_20_seconds ]
  }