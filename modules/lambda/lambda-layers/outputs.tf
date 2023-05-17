output "lambda_layer_arn" {
  value = aws_lambda_layer_version.lambda_layers.arn
}

output "lambda_layer_version_arn" {
  value = aws_lambda_layer_version.lambda_layers.layer_arn
}