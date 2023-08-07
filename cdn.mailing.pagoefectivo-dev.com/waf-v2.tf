

resource "aws_wafv2_web_acl" "acl-plugin" {
  name        = "cdn-mailing-waf-acl"
  description = "cdn mailing cloudfront-Waf"
  scope       = "CLOUDFRONT"

  default_action {
    block {}
  }

  rule {
    name     = "rate-limit-ip"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 10000
        aggregate_key_type = "IP"

        scope_down_statement {
          geo_match_statement {
            country_codes = ["US", "NL"]
          }
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AWS-WAF-rate-rule"
      sampled_requests_enabled   = false
    }
  }
  rule {
    name     = "cdn-mailing-rule-natgw-access"
    priority = 2
    action {
      allow {}
    }
    statement {
      ip_set_reference_statement {
        arn = data.aws_wafv2_ip_set.ipset-natgw.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "cdn-mailing-rule-natgw-access"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "cdn-mailing-rule-vpnps-access"
    priority = 3
    action {
      allow {}
    }
    statement {
      ip_set_reference_statement {
        arn = data.aws_wafv2_ip_set.ipset-vpnpaysafe.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "cdn-mailing-rule-rule-vpnps-access"
      sampled_requests_enabled   = true
    }
  }



  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "AWS-WAF-cdn"
    sampled_requests_enabled   = true
  }
}

#resource "aws_wafv2_web_acl_association" "association_waf" {
#  depends_on = [
#    aws_cloudfront_distribution.s3_distribution
#  ]
#  resource_arn = aws_cloudfront_distribution.s3_distribution.arn
#  web_acl_arn  = aws_wafv2_web_acl.acl-plugin.arn
#}