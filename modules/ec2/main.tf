# EC2 Instance
resource "aws_instance" "wordpress" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_a_id
  vpc_security_group_ids = [var.ec2_sg_id]
  iam_instance_profile   = var.instance_profile_name

  user_data = templatefile("${path.root}/scripts/install_wordpress.sh", {
    db_name     = var.db_name
    db_username = var.db_username
    db_password = var.db_password
    db_host     = var.db_host
  })

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  tags = { Name = "${var.project_name}-server" }
}

# Register EC2 with ALB Target Group
resource "aws_lb_target_group_attachment" "wordpress" {
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.wordpress.id
  port             = 80
}