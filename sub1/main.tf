resource "aws_iam_role" "lambda_role" {
  name = "tf-lambda-for-module-role-9olf1xkl"

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

  name        = "AWSLambdaBasicExecutionRole-16cb508c-e9d5-4e7d-b80a-d2738e03667e"
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
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.AWSLambdaBasicExecutionRole-16cb508c-e9d5-4e7d-b80a-d2738e03667e.arn
}

resource "null_resource" "lambda_dependencies" {
  provisioner "local-exec" {
    command = "cd ./lambda && npm install --legacy-peer-deps"
  }
}

data "archive_file" "task_payload_zip" {
  type        = "zip"
  source_dir  = "./lambda"
  output_path = "./task_payload.zip"
}

resource "aws_lambda_function" "task_payload" {
  function_name    = "tf-lambda-for-module"
  filename         = data.archive_file.task_payload_zip.output_path
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs14.x"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = data.archive_file.task_payload_zip.output_base64sha256
  publish          = true
}
