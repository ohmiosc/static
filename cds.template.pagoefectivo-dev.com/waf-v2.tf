resource "aws_wafv2_ip_set" "ipset-natgw" {
  name               = "pe-dev-ipset-natgw"
  description        = "Whitelist - List IPs NatGW."
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = ["${data.aws_nat_gateway.ngw[0].public_ip}/32", "${data.aws_nat_gateway.ngw[1].public_ip}/32"]
}

resource "aws_wafv2_ip_set" "ipset-vpnpaysafe" {
  name               = "pe-dev-ipset-vpnpaysafe"
  description        = "Whitelist - List IPs VPN-Paysafe."
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = ["18.214.115.95/32", "99.14.137.73/32", "87.120.141.75/32", "87.120.141.76/32", "213.208.158.212/32", "38.74.6.20/32", "38.117.126.11/32", "54.209.34.118/32", "38.117.126.142/32", "44.208.219.192/32", "115.114.129.142/32", "38.74.7.20/32", "20.73.226.224/31", "54.154.244.180/32", "87.120.141.83/32", "52.154.244.181/32", "52.154.244.180/31", "12.131.147.68/32", "208.97.237.201/32", "213.208.158.220/32", "38.113.180.40/32", "208.87.232.0/21"]
}


resource "aws_wafv2_web_acl" "acl-plugin" {
  name        = "cds-template-waf-acl"
  description = "cds template-cloudfront-Waf"
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
    name     = "cds-template-rule-natgw-access"
    priority = 2
    action {
      allow {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipset-natgw.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "cds-template-rule-natgw-access"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "cds-template-rule-vpnps-access"
    priority = 3
    action {
      allow {}
    }
    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipset-vpnpaysafe.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "cds-template-rule-rule-vpnps-access"
      sampled_requests_enabled   = true
    }
  }



  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "AWS-WAF-cds"
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