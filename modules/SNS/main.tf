resource "aws_sns_topic" "updates" {
  name = "${var.name}"
  display_name = "${var.dispay_name}"
  
  tags = {
    "Name" = "${var.name}"
  }

  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultRequestPolicy": {
      "headerContentType": "text/plain; charset=UTF-8"
    }
  }
}
EOF
}

/*
resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = "${var.topic.arn}"
  protocol  = "${var.protocol}"
  endpoint  = "${module.lambda.aws_iam_role.payload.arn}" # "${var.endpoint}"

  application_success_feedback_role_arn = "arn:aws:iam::731672801406:role/SNSSuccessFeedback"
  application_failure_feedback_role_arn = "arn:aws:iam::731672801406:role/SNSFailureFeedback"

  http_success_feedback_role_arn = "arn:aws:iam::731672801406:role/SNSSuccessFeedback"
  http_failure_feedback_role_arn  = "arn:aws:iam::731672801406:role/SNSFailureFeedback"

  lambda_success_feedback_role_arn = "arn:aws:iam::731672801406:role/SNSSuccessFeedback"
  lambda_failure_feedback_role_arn = "arn:aws:iam::731672801406:role/SNSFailureFeedback"

  sqs_success_feedback_role_arn = ""
  sqs_failure_feedback_role_arn = ""

}
*/