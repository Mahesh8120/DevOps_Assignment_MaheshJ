########################################
# AWS WAFv2 WEB ACL (REGIONAL - ALB)
########################################

resource "aws_wafv2_web_acl" "waf" {
  name  = "secure-app-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  ########################################
  # RATE LIMITING RULE (DDoS protection)
  ########################################
  rule {
    name     = "RateLimitRule"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "rateLimitRule"
    }
  }

  ########################################
  # AWS MANAGED RULES (COMMON ATTACKS)
  ########################################
  rule {
    name     = "AWSManagedCommonRules"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      sampled_requests_enabled   = true
      cloudwatch_metrics_enabled = true
      metric_name                = "commonRules"
    }
  }

  ########################################
  # WEB ACL VISIBILITY
  ########################################
  visibility_config {
    sampled_requests_enabled   = true
    cloudwatch_metrics_enabled = true
    metric_name                = "secure-app-waf"
  }
}


########################################
# WAF ASSOCIATION WITH ALB
########################################

resource "aws_wafv2_web_acl_association" "assoc" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.waf.arn

  depends_on = [
    aws_lb.alb,
    aws_lb_listener.http,
    aws_lb_listener.https,
    aws_wafv2_web_acl.waf
  ]
}