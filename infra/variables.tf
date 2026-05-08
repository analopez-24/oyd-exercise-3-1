variable "aws_region" {
  description = "AWS region where all resources will be deployed"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "name" {
  description = "Base name used to identify resources created by the module"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t4g.nano"
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to reach the instance on port 8080"
  type        = list(string)
}

variable "app_s3_bucket" {
  description = "Name of the S3 bucket that holds server.rb"
  type        = string
}
