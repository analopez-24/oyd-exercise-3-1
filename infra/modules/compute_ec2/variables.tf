variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
}

variable "name" {
  description = "Base name used to identify resources created by this module"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance (must match the target architecture)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type (must match the architecture of the chosen AMI)"
  type        = string
  default     = "t4g.nano"
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to reach the instance on the application port"
  type        = list(string)
}

variable "app_s3_bucket" {
  description = "Name of the S3 bucket that holds the server.rb application binary"
  type        = string
}
