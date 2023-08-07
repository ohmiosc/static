
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
