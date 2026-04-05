output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.wordpress.domain_name
}

output "cloudfront_oai_iam_arn" {
  description = "OAI IAM ARN for S3 bucket policy"
  value       = aws_cloudfront_origin_access_identity.oai.iam_arn
}