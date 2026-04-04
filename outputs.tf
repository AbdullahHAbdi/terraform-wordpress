output "instance_id" {
    description = "EC2 instance ID"
    value       = aws_instance.wordpress.id
}

output "public_ip" {
  description = "Public IP of the Wordpress instance"
  value       = aws_instance.wordpress.public_ip
}

output "wordpress_url" {
  description = "Wordpress site url"
  value       = "http://${aws_instance.wordpress.public_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.wordpress.public_ip}"
}