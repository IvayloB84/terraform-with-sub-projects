data "aws_caller_identity" "current" {}

locals {
  layer_src_path = "./nodejs"
  destination_dir = "${path.module}/layers/${var.layer_name}"
}

resource "null_resource" "layer_dependencies" {
  provisioner "local-exec" {
    command = "mkdir -p ${local.destination_dir}/nodejs/ && rsync -av --exclude={'*.tf','*.tfstate*','*./*','*terraform*','lambda/','*.zip'} ./ ./nodejs/ && cd ./nodejs/ && npm install --legacy-peer-deps"
    interpreter = ["/bin/bash", "-c"]
  } 
}

data "archive_file" "local_archive" {
  type        = "zip"
  source_dir  = "./"
  output_path = "${local.destination_dir}/${var.layer_name}.zip"
  depends_on = [ 
    null_resource.layer_dependencies
   ]
}

resource "aws_lambda_layer_version" "lambda_layers" {
  filename   = "${local.destination_dir}.zip"
  layer_name = var.layer_name

  compatible_runtimes = ["nodejs14.x","nodejs16.x"]

  depends_on = [
    data.archive_file.local_archive
  ]
}