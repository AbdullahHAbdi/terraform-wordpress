output "cloudfront_domain_name" {
  description = "CloudFront URL to access WordPress"
  value       = module.cloudfront.cloudfront_domain_name
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "rds_endpoint" {
  description = "RDS endpoint"
  value       = module.rds.rds_endpoint
}

output "wordpress_url" {
  description = "WordPress site URL via CloudFront"
  value       = "http://${module.cloudfront.cloudfront_domain_name}"
}