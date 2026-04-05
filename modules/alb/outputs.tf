output "alb_dns_name" {
  description = "ALB DNS name for CloudFront origin"
  value       = aws_lb.wordpress.dns_name
}

output "target_group_arn" {
  description = "Target group ARN for EC2 registration"
  value       = aws_lb_target_group.wordpress.arn
}