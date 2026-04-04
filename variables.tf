variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Prefix used for all resources names and tags"
  type        = string
  default     = "wordpress-tf"
}

variable "instance_type" {
    description = "EC2 instance type"
    type        = string
    default     = "t3.micro"
} 

variable "key_name" {
  description = "Name of your exisiting EC2 key pair"
  type        = string
}

variable "db_name" {
  description = "Wordpress database name"
  type        = string
  default     = "wordpress"
}

variable "db_user" {
  description = "Wordpress database user"
  type        = string
  default     = "wpuser"
}

variable "db_password" {
  description = "Wordpress database password"
  type        = string
  sensitive   = true
}

variable "ami_id" {
    description = "Amazon Linux 2023 AMI ID"
    type        = string
    default     = "ami-02f986bab3de34d0d"
}