resource "aws_iam_role" "payload" {
  name = var.iam_role_name

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

resource "aws_iam_policy" "AWSLambdaBasicExecutionRole-f81" {

  name        = var.iam_policy_name
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
  policy_arn = aws_iam_policy.AWSLambdaBasicExecutionRole-f81.arn
}

resource "null_resource" "lambda_dependencies" {

/*
  triggers = {
    src_hash = "${data.archive_file.payload_zip.output_sha}"
  }
   triggers = {
    always_run = "${timestamp()}"
  } */

  provisioner "local-exec" {
    command     = "mkdir -p ./lambda/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip'} ./ ./lambda/ && cd ./lambda/ && npm install --legacy-peer-deps && cd -"
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "time_sleep" "wait" {
  depends_on = [
    null_resource.lambda_dependencies
  ]
create_duration = "10s"
/* triggers = {
arn = aws_iam_role.payload.arn
  } */
}

data "archive_file" "payload_zip" {
  type        = "zip"
  source_dir  = "./lambda"
  output_path = "./payload.zip"

/*    depends_on  = [
    null_resource.lambda_dependencies,
    ] */
}

resource "aws_lambda_function" "payload" {
  function_name = var.function_name
  filename      = data.archive_file.payload_zip.output_path
  role          = aws_iam_role.payload.arn
  handler       = var.lambda_handler
  runtime       = var.compatible_runtimes
  timeout = 30
  depends_on = [
    aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role,
    null_resource.lambda_dependencies, resource.time_sleep.wait
  ]
  source_code_hash = data.archive_file.payload_zip.output_base64sha256
  publish          = true
}