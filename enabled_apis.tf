locals {
  services = toset([
    "appengine.googleapis.com", # App Engine Admin API
  ])
}

resource "google_project_service" "service" {
  for_each = local.services

  project = var.project_id
  service = each.value
}