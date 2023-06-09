data "aws_caller_identity" "current" {}

locals {

  lambda_src_path = "./lambda"
  //  create          = var.create

  layer_src_path  = "./source"
  destination_dir = "${path.module}/layers/${var.layer_name}"
}

resource "null_resource" "layer_dependencies" {

  triggers = {
    dependencies_versions = filemd5("./index.js")
    create_file           = fileexists("./readme.txt")
    updated_at            = timestamp()
  }

  provisioner "local-exec" {
    command     = "mkdir -p ./source/nodejs/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip','source/'} ./ ./source/nodejs/ && cd ./source/nodejs/ && npm install --legacy-peer-deps && cd -"
    interpreter = ["/bin/bash", "-c"]
  }
}

data "archive_file" "local_archive" {
  type        = "zip"
  source_dir  = local.layer_src_path
  output_path = "${local.destination_dir}/${var.layer_name}.zip"
  depends_on = [
    null_resource.layer_dependencies
  ]
}

resource "aws_lambda_layer_version" "lambda_layers" {
  
  for_each = toset(["dev", "staging", "prod"])
  filename   = data.archive_file.local_archive.output_path
  layer_name = "${var.layer_name}:${each.value}"
  source_code_hash    = data.archive_file.local_archive.output_base64sha256
  compatible_runtimes = ["nodejs14.x", "nodejs16.x"]

  skip_destroy          = true

  depends_on = [
    data.archive_file.local_archive,
  ]
}