provider "scaleway" {
  zone   = var.scaleway_zone
  region = var.scaleway_region
}

provider "cloudflare" {}

provider "aws" {
  region = var.aws_region
}

module "scaleway_instance" {
  source = "./modules/scaleway-module"

  instance_type         = var.instance_type
  project_id            = var.project_id
  ssh_key               = var.ssh_key
  scaleway_ansible_user = var.scaleway_ansible_user
  admin_cidrs           = var.admin_cidrs
}

module "cloudflare_dns" {
  source = "./modules/cloudflare-module"

  environment = var.environment
  domain_name = var.domain_name
  instance_ip = module.scaleway_instance.instance_public_ip
}

module "aws_storage" {
  count  = var.enable_storage ? 1 : 0
  source = "./modules/aws-module"

  environment    = var.environment
  company_name   = var.company_name
  public_key_pem = var.cloudfront_public_key_pem
}
