resource "aws_s3_bucket" "sprintray-tf-state-files" {
  bucket = "sprintray-tf-state-files"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}