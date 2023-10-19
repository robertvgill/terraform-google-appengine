resource "google_app_engine_service_split_traffic" "appengine_standard" {
  for_each = {
    for k, v in var.standard_app_versions : k => v
    if v.create
  }

  service         = format("%s", each.key)
  migrate_traffic = lookup(each.value, "migrate_traffic", null)

  dynamic "split" {
    for_each = var.split
    content {
      allocations = {
        (google_app_engine_standard_app_version.appengine_standard[each.key].version_id) = split.value["allocations"]
      }
      shard_by = split.value["shard_by"]
    }
  }
}

resource "google_app_engine_service_split_traffic" "appengine_flexible" {
  for_each = {
    for k, v in var.flexible_app_versions : k => v
    if v.create
  }

  service         = format("%s", each.key)
  migrate_traffic = lookup(each.value, "migrate_traffic", null)

  dynamic "split" {
    for_each = var.split
    content {
      allocations = {
        (google_app_engine_flexible_app_version.appengine_flexible[each.key].version_id) = split.value["allocations"]
      }
      shard_by = split.value["shard_by"]
    }
  }
}