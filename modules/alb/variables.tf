variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID from vpc module"
  type        = string
}

variable "public_subnet_a_id" {
  description = "Public subnet A ID from vpc module"
  type        = string
}

variable "public_subnet_b_id" {
  description = "Public subnet B ID from vpc module"
  type        = string
}

variable "alb_sg_id" {
  description = "ALB security group ID from security_groups module"
  type        = string
}