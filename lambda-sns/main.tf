provider "aws" {
  region = "us-west-2"   
}

data "aws_caller_identity" "current" {}



resource "aws_sns_topic" "user_updates" {
  name = "tf-sns-topic"
}

resource "aws_sns_topic_policy" "default" {
  arn = aws_sns_topic.test.arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        var.account-id,
      ]
    }

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.user_updates.arn,
    ]

    sid = "__default_statement_ID"
  }
}
