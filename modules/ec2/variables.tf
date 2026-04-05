variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
}

variable "ami_id" {
  description = "Amazon Linux 2023 AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "private_subnet_a_id" {
  description = "Private subnet A ID from vpc module"
  type        = string
}

variable "ec2_sg_id" {
  description = "EC2 security group ID from security_groups module"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name from iam module"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN from alb module"
  type        = string
}

variable "db_name" {
  description = "WordPress database name"
  type        = string
}

variable "db_username" {
  description = "RDS master username"
  type        = string
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "RDS endpoint from rds module"
  type        = string
}