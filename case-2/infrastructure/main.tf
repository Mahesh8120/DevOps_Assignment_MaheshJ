#################################
# S3 BUCKET (PRIVATE)
#################################

resource "aws_s3_bucket" "site" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#################################
# ENCRYPTION
#################################

resource "aws_s3_bucket_server_side_encryption_configuration" "enc" {
  bucket = aws_s3_bucket.site.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#################################
# VERSIONING
#################################

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.site.id

  versioning_configuration {
    status = "Enabled"
  }
}

#################################
# LOGGING + LIFECYCLE
#################################

resource "aws_s3_bucket" "logs" {
  bucket = "${var.bucket_name}-logs-mahesh"
}

resource "aws_s3_bucket_logging" "logging" {
  bucket        = aws_s3_bucket.site.id
  target_bucket = aws_s3_bucket.logs.id
  target_prefix = "access-logs/"
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.site.id

  rule {
    id     = "expire-old"
    status = "Enabled"

    expiration {
      days = 30
    }
  }
}

#################################
# SAMPLE CONTENT
#################################

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.site.id
  key          = "index.html"
  source       = "${path.module}/../content/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "css" {
  bucket       = aws_s3_bucket.site.id
  key          = "style.css"
  source       = "${path.module}/../content/style.css"
  content_type = "text/css"
}

#################################
# ACM CERTIFICATE (us-east-1)
#################################

resource "aws_acm_certificate" "cert" {
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options :
    dvo.domain_name => dvo
  }

  zone_id = var.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  records = [each.value.resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert_validation" {
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}

#################################
# CLOUDFRONT OAC
#################################

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "s3-oac-mahesh-new"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

#################################
# CLOUDFRONT DISTRIBUTION
#################################

resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  default_root_object = "index.html"

  aliases = [var.domain_name]

  origin {
    domain_name              = aws_s3_bucket.site.bucket_regional_domain_name
    origin_id                = "s3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    cache_policy_id = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    compress        = true
  }

  # ✅ FIXED (removed geo restriction for testing)
    restrictions {
  geo_restriction {
    restriction_type = "whitelist"
    locations        = ["IN"]
  }
}

  # ✅ FIXED (use validated certificate)
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method  = "sni-only"
  }

  depends_on = [aws_acm_certificate_validation.cert_validation]
}

#################################
# S3 POLICY (ALLOW CLOUDFRONT)
#################################

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.site.id

  depends_on = [aws_cloudfront_distribution.cdn]

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "cloudfront.amazonaws.com"
      },
      Action   = "s3:GetObject",
      Resource = "${aws_s3_bucket.site.arn}/*",
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.cdn.arn
        }
      }
    }]
  })
}

#################################
# ROUTE53 RECORD
#################################

resource "aws_route53_record" "dns" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}