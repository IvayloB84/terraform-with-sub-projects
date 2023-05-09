locals {
  lambda_src_path = "./lambda"
}

resource "aws_iam_role" "payload" {
  name = "${var.iam_role_name}"

  assume_role_policy = <<EOF
  
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"    
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "AWSLambdaBasicExecutionRole" {

  name        = "${var.iam_policy_name}"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy      = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.payload.name
  policy_arn = aws_iam_policy.AWSLambdaBasicExecutionRole.arn
}

resource "null_resource" "archive" {

  triggers = {
    dependencies_versions = filemd5("./index.js")
    create_file = fileexists("./readme.txt")
    updated_at = timestamp() 

  }

  /*     triggers = {
    updated_at = timestamp()
  } 
*/

  provisioner "local-exec" {

    command     = "mkdir -p ./lambda/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip'} ./ ./lambda/ && cd ./lambda && npm install --legacy-peer-deps"
    interpreter = ["/bin/bash", "-c"]
  }
}

# resource "random_uuid" "lambda_src_hash" {
#   keepers = {
#     for filename in setunion(
#       fileset(local.lambda_src_path, "./*.js"),
#       fileset(local.lambda_src_path, "./readme.txt"),
#       fileset(local.lambda_src_path, "./**/*.json")
#     ) :
#     filename => filemd5("${local.lambda_src_path}/${filename}")
#   }
# }

data "archive_file" "payload_zip" {
  type        = "zip"
  source_dir  = local.lambda_src_path
  output_path = "payload.zip"
/*   excludes = [
    "*.terraform*",
    "*.tfstate",
    "*.tf",
    "payload.zip",
    "lambda",
    "*./*"
  ] */

  depends_on = [
    null_resource.archive
  ]
}

resource "time_sleep" "wait_20_seconds" {
  depends_on = [null_resource.archive]

  create_duration = "20s"
}

resource "aws_lambda_function" "payload" {
  function_name = "${var.function_name}"
  filename      = data.archive_file.payload_zip.output_path
  role          = aws_iam_role.payload.arn
  handler       = "${var.lambda_handler}"
  runtime       = "${var.compatible_runtimes}"
  timeout       = 90
  depends_on = [
    aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role,
    data.archive_file.payload_zip,
  ]

  source_code_hash = data.archive_file.payload_zip.output_base64sha256
  publish          = true
}