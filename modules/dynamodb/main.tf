data "aws_caller_identity" "current" {}

resource "aws_dynamodb_table" "basic-db-table" {
    name = var.name 
    billing_mode = var.billing_mode
    read_capacity = var.read_capacity 
    write_capacity = var.write_capacity
    hash_key = var.hash_key
    range_key = var.range_key

    attribute {
      name = "UserId"
      type = "S"
    }

    attribute {
      name = "Title"
      type = "S"
    }

    ttl {
        attribute_name = var.attribute_name
        enabled = var.ttl_enabled
    }

    global_secondary_index {
      name = var.global_secondary_indexes
      hash_key = var.hash_key
    }
}