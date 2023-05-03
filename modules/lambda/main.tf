locals {
 policy = templatefile("./config.tpl", {
 })   
}

resource "aws_iam_role" "payload" {
  name ="${var.iam_role_name}"

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
/*
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.payload.name
  policy_arn = aws_iam_policy.AWSLambdaBasicExecutionRole-f81.arn
}

data "template_file" "config" {
  template = "${file("${path.module}/config.tpl")}"
}

resource "local_file" "payload_zip" {
  content  = "${data.template_file.config.rendered}"
  filename = "./lambda/index.js"
}
*/

 resource "null_resource" "prepare_lambda_package" {
  triggers = "${local.policy}"

provisioner "local-exec" {
command = "echo ${local.policy}"
}
/* depends_on = [
local_file.payload_zip
] */
} 

 data "archive_file" "payload_zip" {
  type        = "zip"
  source_dir  = "./lambda"
  output_path = "./payload.zip"

/*     depends_on  = [
    local_file.payload_zip
    ] */
} 

resource "aws_lambda_function" "payload" {
  function_name = "${var.function_name}"
  filename      = data.archive_file.payload_zip.output_path
  role          = "${aws_iam_role.payload.arn}"
  handler       = "${var.lambda_handler}"
  runtime       = "${var.compatible_runtimes}"
  depends_on = [
    aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role,
    data.archive_file.payload_zip
  ]

 source_code_hash = data.archive_file.payload_zip.output_base64sha256
  publish          = true
}