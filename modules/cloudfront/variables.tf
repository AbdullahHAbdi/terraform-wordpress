variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS name from alb module"
  type        = string
}

variable "s3_bucket_domain_name" {
  description = "S3 bucket domain name from s3 module"
  type        = string
}