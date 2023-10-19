resource "google_app_engine_application_url_dispatch_rules" "appengine_standard" {
  for_each = {
    for k, v in var.standard_app_versions : k => v
    if v.create
  }

  project = var.project_id

  dynamic "dispatch_rules" {
    for_each = {
      for k, v in each.value : k => v
      if k == "dispatch_rules"
    }
    content {
      domain  = lookup(dispatch_rules.value, "domain", null)
      path    = lookup(dispatch_rules.value, "path", null)
      service = format("%s", each.key)
    }
  }

  depends_on = [
    google_app_engine_standard_app_version.appengine_standard,
  ]
}

resource "google_app_engine_application_url_dispatch_rules" "appengine_flexible" {
  for_each = {
    for k, v in var.flexible_app_versions : k => v
    if v.create
  }

  project = var.project_id

  dynamic "dispatch_rules" {
    for_each = {
      for k, v in each.value : k => v
      if k == "dispatch_rules"
    }
    content {
      domain  = lookup(dispatch_rules.value, "domain", null)
      path    = lookup(dispatch_rules.value, "path", null)
      service = format("%s", each.key)
    }
  }

  depends_on = [
    google_app_engine_flexible_app_version.appengine_flexible,
  ]
}
