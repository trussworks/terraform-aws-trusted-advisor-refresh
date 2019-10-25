variable "cloudwatch_logs_retention_days" {
  default     = 90
  description = "Number of days to keep logs in AWS CloudWatch."
  type        = string
}

variable "environment" {
  description = "Environment tag, e.g prod."
}

variable "interval_minutes" {
  default     = 60
  description = "How often to update Trusted Advisor."
  type        = string
}

variable "s3_bucket" {
  description = "The name of the S3 bucket used to store the Lambda builds."
  type        = string
}

variable "version_to_deploy" {
  description = "The version the Lambda function to deploy."
  type        = string
}

