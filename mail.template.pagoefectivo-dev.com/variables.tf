variable "region" {
  default = "us-east-1"
  type        = string
  description = "AWS Region"
}

variable "product" {
  default = "portal"
  type        = string
  description = "This name must be unique within your AWS account."
}

variable "environment" {
  default = "dev"
  type        = string
  description = "The envrionment where it will be deployed"

}

variable "environment_prefix" {
  default     = "dev"
  type        = string
  description = "The envrionment prefix where it will be deployed"

}

variable "domain" {
  default = "pagoefectivo-dev.com"
  type        = string
  description = "The Domain PE"

}

variable "arn_certificate_pe" {
  #default = "arn:aws:acm:us-east-1:929226109038:certificate/88b22375-2035-450d-aab8-96a93d9671b5"
  default = "arn:aws:acm:us-east-1:098034669653:certificate/9e37469d-0100-4411-b7fa-e7ebd14e9873"
  type        = string
  description = "The Domain PE"

}

variable "zone_id_public" {
  description = "Route53 Zone ID  Public of the Cloudfront CNAME record.  Also requires domain."
  type        = string
  default     = "Z3SC3BPORFB108"
}

variable "zone_id_private" {
  description = "Route53 Zone ID of the Cloudfront CNAME record.  Also requires domain."
  type        = string
  default     = "Z058873539V836CMACHV1"
}