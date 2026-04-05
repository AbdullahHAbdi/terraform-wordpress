resource "aws_cloudfront_distribution" "wordpress" {
  enabled             = true
  comment             = "${var.project_name} distribution"
  default_root_object = "index.php"

  # Origin 1 — ALB
  origin {
    domain_name = var.alb_dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Origin 2 — S3
  origin {
    domain_name = var.s3_bucket_domain_name
    origin_id   = "s3-origin"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  # Default behavior — route to ALB
  default_cache_behavior {
  allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
  cached_methods         = ["GET", "HEAD"]
  target_origin_id       = "alb-origin"
  viewer_protocol_policy = "allow-all"

  forwarded_values {
    query_string = true
    headers      = ["Host", "Authorization", "CloudFront-Forwarded-Proto"]

    cookies {
      forward = "all"
    }
  }
}

  # Cache behavior — route /wp-content/uploads/* to S3
  ordered_cache_behavior {
    path_pattern           = "/wp-content/uploads/*"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = { Name = "${var.project_name}-cf" }
}

# Origin Access Identity — allows CloudFront to access private S3
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "${var.project_name} OAI"
}