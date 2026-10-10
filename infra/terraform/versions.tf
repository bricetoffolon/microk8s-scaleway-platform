terraform {
  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
    scaleway = {
      source  = "scaleway/scaleway"
      version = ">= 2.40, < 3.0"
    }
  }

  # Partial configuration: pass -backend-config=envs/<env>.backend.hcl at init.
  backend "s3" {}
}
