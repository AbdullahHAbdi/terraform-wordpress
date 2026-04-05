variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR for public subnet A"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR for public subnet B"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_a_cidr" {
  description = "CIDR for private subnet A"
  type        = string
  default     = "10.0.16.0/20"
}

variable "private_subnet_b_cidr" {
  description = "CIDR for private subnet B"
  type        = string
  default     = "10.0.32.0/20"
}

variable "az_a" {
  description = "Availability zone A"
  type        = string
  default     = "us-east-2a"
}

variable "az_b" {
  description = "Availability zone B"
  type        = string
  default     = "us-east-2b"
}