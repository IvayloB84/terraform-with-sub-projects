resource "aws_s3_bucket" "sprintray-tf-state-files" {
  bucket = "sprintray-tf-state-files"
}

resource "aws_s3_bucket_acl" "sprintray-tf-state-files" {
  bucket = aws_s3_bucket.sprintray-tf-state-files.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.sprintray-tf-state-files.id
  versioning_configuration {
    status = "Enabled"
  }
}