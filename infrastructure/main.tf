# Main Terraform file for AWS infrastructure

provider "aws" {
  region = var.aws_region
}

# S3 bucket for Lambda deployment packages
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "${var.project_name}-lambda-artifacts"
  force_destroy = true
}

# IAM role for Lambda functions
resource "aws_iam_role" "lambda_exec" {
  name = "${var.project_name}-lambda-exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda: Recommendation
resource "aws_lambda_function" "recommendation" {
  function_name = "${var.project_name}-recommendation-lambda"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = "recommendation-lambda.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      # Add Algolia or OpenSearch env vars here
    }
  }
}

# Lambda: Enrollment
resource "aws_lambda_function" "enrollment" {
  function_name = "${var.project_name}-enrollment-lambda"
  s3_bucket     = aws_s3_bucket.lambda_bucket.id
  s3_key        = "enrollment-lambda.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      # Add DB connection env vars here
    }
  }
}

# API Gateway REST API
resource "aws_api_gateway_rest_api" "plugin_api" {
  name        = "${var.project_name}-plugin-api"
  description = "API Gateway for ChatGPT plugin endpoints"
}

# API Gateway Resources
resource "aws_api_gateway_resource" "recommendations" {
  rest_api_id = aws_api_gateway_rest_api.plugin_api.id
  parent_id   = aws_api_gateway_rest_api.plugin_api.root_resource_id
  path_part   = "recommendations"
}

resource "aws_api_gateway_resource" "enrollments" {
  rest_api_id = aws_api_gateway_rest_api.plugin_api.id
  parent_id   = aws_api_gateway_rest_api.plugin_api.root_resource_id
  path_part   = "enrollments"
}

# API Gateway Methods and Integrations
resource "aws_api_gateway_method" "recommendations_get" {
  rest_api_id   = aws_api_gateway_rest_api.plugin_api.id
  resource_id   = aws_api_gateway_resource.recommendations.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "recommendations_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.plugin_api.id
  resource_id             = aws_api_gateway_resource.recommendations.id
  http_method             = aws_api_gateway_method.recommendations_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.recommendation.invoke_arn
}

resource "aws_api_gateway_method" "enrollments_get" {
  rest_api_id   = aws_api_gateway_rest_api.plugin_api.id
  resource_id   = aws_api_gateway_resource.enrollments.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "enrollments_lambda" {
  rest_api_id             = aws_api_gateway_rest_api.plugin_api.id
  resource_id             = aws_api_gateway_resource.enrollments.id
  http_method             = aws_api_gateway_method.enrollments_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.enrollment.invoke_arn
}

# Lambda permissions for API Gateway
resource "aws_lambda_permission" "recommendation_api" {
  statement_id  = "AllowAPIGatewayInvokeRecommendation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.recommendation.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.plugin_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "enrollment_api" {
  statement_id  = "AllowAPIGatewayInvokeEnrollment"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.enrollment.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.plugin_api.execution_arn}/*/*"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "plugin_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.recommendations_lambda,
    aws_api_gateway_integration.enrollments_lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.plugin_api.id
  stage_name  = "prod"
}

# EKS Cluster (using module)
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version = "1.29"
  subnets         = var.subnets
  vpc_id          = var.vpc_id
  # ... other required EKS module variables
} 