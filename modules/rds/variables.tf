variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
}

variable "private_subnet_a_id" {
  description = "Private subnet A ID from vpc module"
  type        = string
}

variable "private_subnet_b_id" {
  description = "Private subnet B ID from vpc module"
  type        = string
}

variable "rds_sg_id" {
  description = "RDS security group ID from security_groups module"
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