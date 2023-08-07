variable "region" {
  default     = "us-east-1"
  type        = string
  description = "AWS Region"
}

variable "product" {
  default     = "cde"
  type        = string
  description = "This name must be unique within your AWS account."
}

variable "environment" {
  default     = "dev"
  type        = string
  description = "The envrionment where it will be deployed"

}

variable "environment_prefix" {
  default     = "dev"
  type        = string
  description = "The envrionment prefix where it will be deployed"

}

variable "domain" {
  default     = "pagoefectivo-dev.com"
  type        = string
  description = "The Domain PE"

}

variable "arn_certificate_pe" {
  default     = "arn:aws:acm:us-east-1:098034669653:certificate/e41b1f87-c46c-4117-8b60-67db34078896"
  type        = string
  description = "The Domain PE"

}

variable "zone_id_public" {
  description = "Route53 Zone ID  Public of the Cloudfront CNAME record.  Also requires domain."
  type        = string
  default     = "Z10410561XM70YUEEZIY7"
}

variable "zone_id_private" {
  description = "Route53 Zone ID of the Cloudfront CNAME record.  Also requires domain."
  type        = string
  default     = "Z02722213ER7V57R8AF9O"
}

variable "vpc_name" {
  type    = string
  default = "nonprod.pagoefectivo.vpc"
}