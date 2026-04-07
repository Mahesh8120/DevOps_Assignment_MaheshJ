resource "aws_cloudfront_distribution" "cdn" {

  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443

      # ✅ FIX: use HTTPS to origin (recommended)
      origin_protocol_policy = "https-only"

      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = true
  is_ipv6_enabled = true

  default_cache_behavior {
    target_origin_id = "alb-origin"

    # ✅ Modern methods
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    # ✅ REQUIRED for modern CloudFront (fixes deprecated forwarded_values)
    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6" 
    # (Managed-CachingOptimized)

    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
    # (Managed-AllViewerExceptHostHeader)

    viewer_protocol_policy = "redirect-to-https"

    compress = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}