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
    updated_at = timestamp()
  }

/*
  triggers = {
    create_file = fileexists("./readme.txt")
  } */

  provisioner "local-exec" {
/*     command = "rm -rf ./lambda payload.zip && mkdir -p ./lambda/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip'} ./ ./lambda/ && cd ./lambda/ && npm install --legacy-peer-deps && cd -"
//   interpreter = ["/bin/bash", "-c"] */
command = "mkdir -p ./lambda/ && cp -p index.js && cd ./lambda/ && npm install --legacy-peer-deps && cd -"
    }

/*       triggers = {
    dir_sha1 = sha1(join("", [for f in fileset("./lambda", "*"): filesha1(f)]))
  } */
 }
  data "archive_file" "payload_zip" {
  type        = "zip"
  source_dir  = "./lambda"
  output_path = "./payload.zip"   
  excludes = [
    ".terraform*",
    ".tfstate*",
    "*.tf",
    "payload.zip",
    "lambda"
  ]

  depends_on = [ 
    random_string.r,
    null_resource.archive
   ]
}

resource "random_string" "r" {
  length  = 16
  special = false
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.archive]

  create_duration = "20s"
}

resource "aws_lambda_function" "payload" {
  function_name = var.function_name
  filename      = "${data.archive_file.payload_zip .output_path}"
//  filename = "payload.zip"
  role     = "${aws_iam_role.payload.arn}"
  handler  = "${var.lambda_handler}"
  runtime  = "${var.compatible_runtimes}"
  timeout  = 900
  depends_on = [
    aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role,
    data.archive_file.payload_zip,
    time_sleep.wait_30_seconds
  ]

  source_code_hash = "${data.archive_file.payload_zip.output_base64sha256}"
  publish = true
}                  