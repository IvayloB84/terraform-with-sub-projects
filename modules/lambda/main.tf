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

  provisioner "local-exec" {
//    command = "mkdir -p ./lambda && cd ./lambda && cp -u ../index.js . && npm install --legacy-peer-deps && cd -"  
      command = "mkdir -p ./lambda && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip'} ./ ./lambda/ && cd ./lambda && npm install --legacy-peer-deps && cd -"
  }
}

data "null_data_source" "wait_for_lambda_exporter" {
  inputs = {
    lambda_dependencies_id = "${null_resource.lambda_dependencies.id}"

    source_dir = "./lambda/"
  }
}

 data "archive_file" "payload_zip" {
  type        = "zip"
//  source_dir = "lambda/"
  source_dir = "${data.null_data_source.wait_for_lambda_exporter.outputs["source_dir"]}"
  output_path = "./payload.zip"
  depends_on  = [
    null_resource.lambda_dependencies
    ]
} 

resource "aws_lambda_function" "payload" {
  function_name = var.function_name
  filename      = "${data.archive_file.payload_zip.output_path}"
  role             = aws_iam_role.payload.arn
  handler          = "${var.lambda_handler}"
  runtime          = "${var.compatible_runtimes}"
  depends_on       = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
  source_code_hash = "${data.archive_file.payload_zip.output_base64sha256}"
  publish          = true
}