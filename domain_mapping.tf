resource "google_app_engine_domain_mapping" "appengine_standard" {
  for_each = {
    for k, v in var.standard_app_versions : k => v
    if v.create
  }

  domain_name       = lookup(each.value, "domain_name", null)
  override_strategy = lookup(each.value, "override_strategy", null)
  project           = var.project_id

  dynamic "ssl_settings" {
    for_each = {
      for k, v in each.value : k => v
      if k == "ssl_settings"
    }
    content {
      certificate_id      = lookup(ssl_settings.value, "certificate_id", null)
      ssl_management_type = lookup(ssl_settings.value, "ssl_management_type", null)
    }
  }

  depends_on = [
    google_app_engine_standard_app_version.appengine_standard,
  ]
}

resource "google_app_engine_domain_mapping" "appengine_flexible" {
  for_each = {
    for k, v in var.flexible_app_versions : k => v
    if v.create
  }

  domain_name       = lookup(each.value, "domain_name", null)
  override_strategy = lookup(each.value, "override_strategy", null)
  project           = var.project_id

  dynamic "ssl_settings" {
    for_each = {
      for k, v in each.value : k => v
      if k == "ssl_settings"
    }
    content {
      certificate_id      = lookup(ssl_settings.value, "certificate_id", null)
      ssl_management_type = lookup(ssl_settings.value, "ssl_management_type", null)
    }
  }

  depends_on = [
    google_app_engine_flexible_app_version.appengine_flexible,
  ]
}