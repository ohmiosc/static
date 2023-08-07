
data "aws_vpc" "selected" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_nat_gateways" "ngws" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_nat_gateway" "ngw" {
  count = length(data.aws_nat_gateways.ngws.ids)
  id    = tolist(data.aws_nat_gateways.ngws.ids)[count.index]
}

data "aws_wafv2_ip_set" "ipset-natgw" {
  name  = "pe-dev-ipset-natgw"
  scope = "CLOUDFRONT"
}

data "aws_wafv2_ip_set" "ipset-vpnpaysafe" {
  name  = "pe-dev-ipset-vpnpaysafe"
  scope = "CLOUDFRONT"
}
