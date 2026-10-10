data "cloudflare_zones" "domain_zone" {
  name = var.domain_name
}

locals {
  zone_id = one(data.cloudflare_zones.domain_zone.result[*].id)
  # production serves the apex domain, other environments get <env>.<domain>
  record_name = var.environment == "production" ? var.domain_name : "${var.environment}.${var.domain_name}"
}

resource "cloudflare_dns_record" "app" {
  zone_id = local.zone_id
  comment = "Managed by Terraform (${var.environment})"
  content = var.instance_ip
  name    = local.record_name
  proxied = true
  ttl     = 1 # 1 = automatic
  type    = "A"
}
