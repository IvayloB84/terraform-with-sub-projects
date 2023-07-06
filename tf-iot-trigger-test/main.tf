resource "aws_lambda_function" "tfer--tf-iot-trigger-test" {
  architectures = ["x86_64"]

  ephemeral_storage {
    size = "512"
  }

  function_name                  = "tf-iot-trigger-test"
  handler                        = "index.handler"
  memory_size                    = "128"
  package_type                   = "Zip"
  reserved_concurrent_executions = "-1"
  role                           = "arn:aws:iam::731672801406:role/service-role/tf-iot-trigger-test-role-jk345q6z"
  runtime                        = "nodejs18.x"
  skip_destroy                   = "false"
  source_code_hash               = "MG72HgtEGK/uUjwWCRNPj5Zj2mNaPZkgBXWH9AtuJ8I="
  timeout                        = "3"

  tracing_config {
    mode = "PassThrough"
  }
}

