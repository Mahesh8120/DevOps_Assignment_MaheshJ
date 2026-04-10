resource "aws_cloudfront_distribution" "cdn" {

  ########################################
  # ORIGIN (ALB)
  ########################################
  origin {
    domain_name = aws_lb.alb.dns_name
    origin_id   = "alb-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443

      # IMPORTANT: ALB supports HTTPS (use it safely)
      origin_protocol_policy = "https-only"

      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  ########################################
  # GENERAL SETTINGS
  ########################################
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = ""

  ########################################
  # CACHE BEHAVIOR
  ########################################
  default_cache_behavior {
    target_origin_id = "alb-origin"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    cache_policy_id          = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    origin_request_policy_id = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf"
  }

  ########################################
  # RESTRICTIONS
  ########################################
 
    restrictions {
  geo_restriction {
    restriction_type = "whitelist"
    locations        = ["IN"]
  }
}


  ########################################
  # SSL CERTIFICATE
  ########################################
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}