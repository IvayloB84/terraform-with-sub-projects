provider "aws" {
  region = "us-west-2"
}

module "lambda-container" {
  source = "../modules/lambda/lambda-container/"

  ecr_repository_name = "sub2-lambda-with-container"
  ecr_image_tag = "latest"
  function_name = "sub2-lambda-with-container"
  iam_role      = "sub2-lambda-with-container"
  iam_policy    = "sub2-lambda-with-container"
}