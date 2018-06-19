# userpool/variables
variable "region" {
  default = "us-east-1"
}

variable "hosted_zone" {}

variable "force_destroy" {
  default = false
}

variable "google_client_id" {}
variable "google_client_secret" {}

locals {
  hosted_zone_dash = "${replace(var.hosted_zone, ".", "-")}"
}
