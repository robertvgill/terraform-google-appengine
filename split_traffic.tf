resource "google_app_engine_service_split_traffic" "appengine_standard" {
  for_each = {
    for k, v in var.standard_app_versions : k => v
    if v.create
  }

  service         = format("%s", each.key)
  migrate_traffic = lookup(each.value, "migrate_traffic", null)

  dynamic "split" {
    for_each = {
      for k, v in each.value : k => v
      if k == "split"
    }
    content {
      allocations = {
        (google_app_engine_standard_app_version.appengine_standard[each.key].version_id) = lookup(split.value, "allocations", null)
      }
      shard_by = lookup(split.value, "shard_by", null)
    }
  }

  depends_on = [
    google_app_engine_standard_app_version.appengine_standard,
  ]
}

resource "google_app_engine_service_split_traffic" "appengine_flexible" {
  for_each = {
    for k, v in var.flexible_app_versions : k => v
    if v.create
  }

  service         = format("%s", each.key)
  migrate_traffic = lookup(each.value, "migrate_traffic", null)

  dynamic "split" {
    for_each = {
      for k, v in each.value : k => v
      if k == "split"
    }
    content {
      allocations = {
        (google_app_engine_flexible_app_version.appengine_flexible[each.key].version_id) = lookup(split.value, "allocations", null)
      }
      shard_by = lookup(split.value, "shard_by", null)
    }
  }

  depends_on = [
    google_app_engine_flexible_app_version.appengine_flexible,
  ]
}