variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment (e.g., production, staging)"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_a" {
  type        = string
  description = "CIDR block for public subnet A"
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_b" {
  type        = string
  description = "CIDR block for public subnet B"
  default     = "10.0.2.0/24"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-northeast-1"
}

variable "ecr_repository_url" {
  type        = string
  description = "URL of the ECR image (e.g., 123456789.dkr.ecr.ap-northeast-1.amazonaws.com/your-repo)"
}

variable "container_port" {
  type        = number
  description = "Port number for the container"
  default     = 3000
}

variable "desired_count" {
  type        = number
  description = "Number of tasks to run"
  default     = 1
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "adminpassword123"
}

variable "vpc_id" {
  description = "ID of the VPC to use"
  type        = string
}
