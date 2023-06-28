resource "aws_s3_bucket" "sprintray-tf-state-files" {
  bucket = "sprintray-tf-state-files"

  versioning {
    enabled = true
  }

    lifecycle {
      prevent_destroy = false # should be true to prevent accidentally deleting state file
    }
    versioning {
      enabled = true
    }
    server_side_encryption_configuration {
      rule{
          apply_server_side_encryption_by_default{
              sse_algorithm = "AES256"
          }
      }
    }
}