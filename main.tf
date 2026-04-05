terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# VPC

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
}


# Security Groups

module "security_groups" {
  source           = "./modules/security_groups"
  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  ssh_allowed_cidr = var.ssh_allowed_cidr
}


# IAM

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
}


# RDS

module "rds" {
  source              = "./modules/rds"
  project_name        = var.project_name
  private_subnet_a_id = module.vpc.private_subnet_a_id
  private_subnet_b_id = module.vpc.private_subnet_b_id
  rds_sg_id           = module.security_groups.rds_sg_id
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
}


# ALB

module "alb" {
  source             = "./modules/alb"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  public_subnet_a_id = module.vpc.public_subnet_a_id
  public_subnet_b_id = module.vpc.public_subnet_b_id
  alb_sg_id          = module.security_groups.alb_sg_id
}


# S3

module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}

# S3 Bucket Policy — allow CloudFront OAI to read
resource "aws_s3_bucket_policy" "wordpress_media" {
  bucket = module.s3.bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = module.cloudfront.cloudfront_oai_iam_arn }
        Action    = "s3:GetObject"
        Resource  = "${module.s3.bucket_arn}/*"
      }
    ]
  })
}

# EC2

module "ec2" {
  source                = "./modules/ec2"
  project_name          = var.project_name
  ami_id                = var.ami_id
  instance_type         = var.instance_type
  key_name              = var.key_name
  private_subnet_a_id   = module.vpc.private_subnet_a_id
  ec2_sg_id             = module.security_groups.ec2_sg_id
  instance_profile_name = module.iam.instance_profile_name
  target_group_arn      = module.alb.target_group_arn
  db_name               = var.db_name
  db_username           = var.db_username
  db_password           = var.db_password
  db_host               = module.rds.rds_endpoint
}


# CloudFront

module "cloudfront" {
  source                = "./modules/cloudfront"
  project_name          = var.project_name
  alb_dns_name          = module.alb.alb_dns_name
  s3_bucket_domain_name = module.s3.bucket_domain_name
}