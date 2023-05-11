provider "aws" {
  region = "us-west-2"
}

module "lambda-container" {
  source = "../modules/lambda/lambda-container/"

  ecr_repository_name = "tf-lambda-sub2-with-container-image"
  ecr_image_tag = "latest"
  function_name = "tf-lambda-sub2"
  iam_role      = "tf-lambda-sub2"
  iam_policy    = "tf-lambda-sub2"
}