provider "aws" {
  region = "us-west-2"
}

module "lambda-layer" {
  source = "../modules/lambda/lambda-layers"

  for_each = toset(["dev", "staging", "prod"])
  function_name = "sub3-with-version:${each.value}"
  description   = "Lambda function + version"
}