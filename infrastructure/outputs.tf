output "recommendation_lambda_arn" {
  value = aws_lambda_function.recommendation.arn
}

output "enrollment_lambda_arn" {
  value = aws_lambda_function.enrollment.arn
}

output "api_gateway_url" {
  value = aws_api_gateway_rest_api.plugin_api.execution_arn
}

output "eks_cluster_name" {
  value = module.eks.cluster_id
} 