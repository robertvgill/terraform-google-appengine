data "google_service_account" "appengine_standard" {
  for_each = {
    for k, v in var.standard_app_versions : k => v
    if v.create
  }

  account_id = lookup(each.value, "service_account", null)
}

data "google_service_account" "appengine_flexible" {
  for_each = {
    for k, v in var.flexible_app_versions : k => v
    if v.create
  }

  account_id = lookup(each.value, "service_account", null)
}