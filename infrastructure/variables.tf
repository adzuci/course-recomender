variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "course-recomender"
}

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "course-recomender-eks"
}

variable "vpc_id" {
  description = "VPC ID for EKS cluster"
  type        = string
}

variable "subnets" {
  description = "Subnets for EKS worker nodes"
  type        = list(string)
} 