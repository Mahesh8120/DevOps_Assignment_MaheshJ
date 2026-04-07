resource "aws_route53_record" "alb_dns" {
  zone_id = "Z09532653LYSJAOMBYJTE"

  # Root domain (apex)
  name = "sitaram.icu"
  type = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }

  depends_on = [
    aws_lb.alb
  ]
}