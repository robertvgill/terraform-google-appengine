resource "google_app_engine_application" "appengine_app" {
  count = var.app_engine_create ? 1 : 0

  project        = var.project
  location_id    = var.location_id
  auth_domain    = var.auth_domain
  database_type  = var.database_type
  serving_status = var.serving_status

  dynamic "feature_settings" {
    for_each = var.feature_settings[*]
    content {
      split_health_checks = feature_settings.value.split_health_checks
    }
  }

  dynamic "iap" {
    for_each = var.iap[*]
    content {
      oauth2_client_id     = iap.value.oauth2_client_id
      oauth2_client_secret = iap.value.oauth2_client_secret
    }
  }
}
