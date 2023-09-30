resource "google_app_engine_firewall_rule" "firewall_rule" {
  for_each = {
    for k, v in var.firewall_rules : k => v
    if v.create
  }

  source_range = lookup(each.value, "source_range", null)
  action       = lookup(each.value, "action", null)
  description  = lookup(each.value, "description", null)
  priority     = lookup(each.value, "priority", null)
}