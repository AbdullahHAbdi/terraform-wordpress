output "rds_endpoint" {
  description = "RDS connection endpoint for WordPress"
  value       = aws_db_instance.wordpress.endpoint
}