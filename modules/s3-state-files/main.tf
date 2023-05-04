resource "aws_s3_bucket" "terraform_state_file" {
  bucket = "sprintray-tf-state-files"
  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Terraform state files"
  }
}

resource "aws_s3_bucket_acl" "tf-terraform_state_acl" {
  bucket = aws_s3_bucket.terraform_state_file.id
  acl    = "private"
}

# Enable versioning so we can see the full revision history of our
# state files
resource "aws_s3_bucket_versioning" "versioning_tf_state_file" {
  bucket = aws_s3_bucket.terraform_state_file.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
server_side_encryption_configuration {
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB table name, billing mode, hash key and attribute (S - string)
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "sprintray-tf-state-files"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}