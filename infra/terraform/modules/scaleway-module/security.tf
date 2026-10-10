resource "scaleway_instance_security_group" "www" {
  project_id              = var.project_id
  name                    = "microk8s-sg"
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"

  dynamic "inbound_rule" {
    for_each = setproduct(var.admin_cidrs, ["22", "16443"])
    content {
      action   = "accept"
      ip_range = inbound_rule.value[0]
      port     = inbound_rule.value[1]
    }
  }

  inbound_rule {
    action = "accept"
    port   = "80"
  }

  inbound_rule {
    action = "accept"
    port   = "443"
  }
}
