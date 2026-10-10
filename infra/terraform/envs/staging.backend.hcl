bucket       = "example-platform-tf-state" # created by ../bootstrap
key          = "staging/terraform.tfstate"
region       = "eu-west-3"
encrypt      = true
use_lockfile = true # native S3 locking, Terraform >= 1.11
