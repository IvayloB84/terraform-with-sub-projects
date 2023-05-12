data "aws_caller_identity" "current" {}

locals {
  layer_src_path = "${var.dir}/source"
  destination_dir = "${path.module}/layers/${var.layer_name}"
}

resource "null_resource" "layer_dependencies" {
  provisioner "local-exec" {
    command = "mkdir -p ./source/nodejs/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip','source/'}./ ./source/nodejs/ && cd ./source/nodejs/ && npm install --legacy-peer-deps && cd -"
    interpreter = ["/bin/bash", "-c"]
  } 
}

data "archive_file" "local_archive" {
  type        = "zip"
  source_dir  = "${local.layer_src_path}"
  output_path = "${local.destination_dir}/${var.layer_name}.zip"
  depends_on = [ 
    null_resource.layer_dependencies
   ]
}

resource "aws_lambda_layer_version" "lambda_layers" {
  filename   = "${local.destination_dir}/${var.layer_name}.zip"
  layer_name = var.layer_name

  compatible_runtimes = ["nodejs14.x", "nodejs16.x"]

  depends_on = [
    data.archive_file.local_archive
  ]
}