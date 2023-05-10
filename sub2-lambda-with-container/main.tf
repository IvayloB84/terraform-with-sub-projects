provider "aws" {
  region = "us-west-2"
}

module "lambda-container" {
  source = "../modules/lambda/lambda-container/"

  function_name = "sub2-lambda-with-container"
  iam_role      = "sub2-lambda-with-container"
  iam_policy    = "sub2-lambda-with-container"
  /*   lambda_handler      = "index.handler"
  compatible_runtimes = "nodejs14.x"
  dir = "sub2-lambda-with-container" */
}