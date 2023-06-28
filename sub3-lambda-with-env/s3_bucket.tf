data "aws_s3_bucket" "bucket" {
  bucket = "sprintray-tf-state-files"
}

output "sprintray-tf-state-files" {
  value = "${data.aws_s3_bucket.bucket.bucket}"
}

resource "aws_s3_bucket" "bucket" {
    count = var.create ? 1 : 0 
    bucket = "sprintray-tf-state-files"
    versioning {
        enabled = true
    }
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
    object_lock_configuration {
        object_lock_enabled = "Enabled"
    }
    tags = {
        Name = "S3 Remote Terraform State Store"
    }
}