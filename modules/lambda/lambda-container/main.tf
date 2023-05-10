## ECR repository with Docker image integration and lambda function

data "aws_caller_identity" "current" {}

locals {
  prefix              = "image"
  region              = "us-west-2"
  account_id          = data.aws_caller_identity.current.account_id
  ecr_repository_name = "${local.prefix}-lambda-container"
  ecr_image_tag       = "latest"
}

resource "aws_ecr_repository" "image_demo_lambda_repository" {
  name         = var.ecr_repository_name
  force_delete = true
}

resource "null_resource" "container_image_requirements" {
  triggers = {
    nodejs_file = md5(file("./index.js"))
    json_file = md5(file("./package.json"))
    docker_file = md5(file("./Dockerfile"))
  }

  provisioner "local-exec" {
    command = <<EOF
           aws ecr get-login-password --region ${local.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${local.region}.amazonaws.com
           docker build -t ${aws_ecr_repository.image_demo_lambda_repository.repository_url}:${local.ecr_image_tag} .
           docker push ${aws_ecr_repository.image_demo_lambda_repository.repository_url}:${local.ecr_image_tag}
       EOF
  }
}

data "aws_ecr_image" "image-demo-lambda-repository" {
  depends_on = [
    null_resource.container_image_requirements
  ]
  repository_name = var.ecr_repository_name
  image_tag       = var.ecr_image_tag
}

 resource "aws_ecr_repository_policy" "git-demo-lambda-repository" {
  repository = aws_ecr_repository.image_demo_lambda_repository.name
  policy     = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "Set the permission for ECR",
        "Effect": "Allow",
        "Principal": "*",
        "Action": [
          "ecr:*"
        ]
      }
    ]
  }
  EOF
}

resource "aws_lambda_function" "image-lambda-function" {
  depends_on = [
    null_resource.container_image_requirements
  ]
  function_name = var.function_name
  role          = aws_iam_role.image-lambda-terraform.arn
  timeout       = 600
  image_uri     = "${aws_ecr_repository.image_demo_lambda_repository.repository_url}@${data.aws_ecr_image.image-demo-lambda-repository.id}"
    image_config {
    command           = ["index.handler"]
  }
  package_type  = "Image"
}

resource "aws_iam_role" "image-lambda-terraform" {
  name               = "${local.prefix}-lambda-role"
  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Action": "sts:AssumeRole",
           "Principal": {
               "Service": "lambda.amazonaws.com"
           },
           "Effect": "Allow"
       }
   ]
}
 EOF
}

data "aws_iam_policy_document" "image-policy-container" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["*"]
    sid       = "CreateCloudWatchLogs"
  }

  statement {
    actions = [
      "codecommit:GitPull",
      "codecommit:GitPush",
      "codecommit:GitBranch",
      "codecommit:ListBranches",
      "codecommit:CreateCommit",
      "codecommit:GetCommit",
      "codecommit:GetCommitHistory",
      "codecommit:GetDifferences",
      "codecommit:GetReferences",
      "codecommit:BatchGetCommits",
      "codecommit:GetTree",
      "codecommit:GetObjectIdentifier",
      "codecommit:GetMergeCommit"
    ]
    effect    = "Allow"
    resources = ["*"]
    sid       = "CodeCommit"
  }
}

resource "aws_iam_policy" "image-demo-container" {
  name   = var.iam_policy
  path   = "/"
  policy = data.aws_iam_policy_document.image-policy-container.json
}
