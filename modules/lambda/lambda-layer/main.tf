data "aws_caller_identity" "current" {}

locals {
  destination_dir = "${path.module}/../layers/${var.layer_name}/"
}

data "archive_file" "local_layer_dependencies" {
  type        = "zip"
  source_dir  = "./"
  output_path = "${local.destination_dir}"
}

resource "aws_lambda_layer_version" "lambda_layers" {
  filename   = "${path.module}/layers/${var_layer_name}/${var.layer_name}.zip"
  layer_name = var.layer_name

  compatible_runtimes = ["nodejs14.x", "nodejs16.x"]

  depends_on = [
    data.archive_file.local_layer_dependencies
  ]
}