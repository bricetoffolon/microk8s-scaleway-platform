terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = ">= 2.40, < 3.0"
    }
  }
  required_version = ">= 1.11.0"
}