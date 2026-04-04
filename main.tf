terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# secuirty group

resource "aws_security_group" "wordpress_sg" {
    name        = "${var.project_name}-sg"
    description = "Allow HTTP, HTTPS, and SSH"

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]  
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name    = "${var.project_name}-sg"
        Project = var.project_name
    }
}

# ec2 instance

resource "aws_instance" "wordpress" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    key_name               = var.key_name
    vpc_security_group_ids = [aws_security_group.wordpress_sg.id]

    user_data = templatefile("${path.module}/scripts/install_wordpress.sh", {
        db_name     = var.db_name
        db_user     = var.db_user
        db_password = var.db_password
    })

    root_block_device {
      volume_size = 20
      volume_type = "gp3"
      encrypted   = true
    }

    tags = {
        Name    = "${var.project_name}-instance"
        Project = var.project_name
    }
}