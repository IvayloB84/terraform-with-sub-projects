resource "aws_dynamodb_table" "state_locking" {
  hash_key = "LockID"
  name     = "sprintray-tf-state-files"
    billing_mode = "PAY_PER_REQUEST"
    attribute {
      name = "LockID"
      type = "S"

    }
  
}