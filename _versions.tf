terraform {
  required_version = ">= 0.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
    context = {
      version = ">=0.0.2"
      source  = "registry.terraform.io/SevenPico/meta"
    }
  }
}
