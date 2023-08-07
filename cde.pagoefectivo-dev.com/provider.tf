provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Product     = "pe"
      Environment = "prod"
      Project     = "cde"
    }
  }
}

terraform {
  #
  # backend "s3" {}
  #backend "s3" {
  #  bucket = "orbis.terraform.state"
  #  key    = "pe/infrastructure/plugins-prestashop/terraform/test2/s3-cloudfront/terraform.state"
  #  region = "us-east-1"
  #}
  required_version = ">= 0.12.0"
}