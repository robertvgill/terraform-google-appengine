resource "google_app_engine_standard_app_version" "appengine_standard" {
  for_each = {
    for k, v in var.standard_app_versions : k => v
    if v.create
  }
  delete_service_on_destroy = lookup(each.value, "delete_service_on_destroy", null)
  env_variables             = lookup(each.value, "env_variables", {})
  inbound_services          = lookup(each.value, "inbound_services", [])
  instance_class            = lookup(each.value, "instance_class", null)
  noop_on_destroy           = lookup(each.value, "noop_on_destroy", null)
  runtime                   = lookup(each.value, "runtime", null)
  runtime_api_version       = lookup(each.value, "runtime_api_version", null)
  service                   = format("%s", each.key)
  service_account           = data.google_service_account.appengine_standard[each.key].name
  threadsafe                = lookup(each.value, "threadsafe", null)
  version_id                = lookup(each.value, "version_id", null)

  dynamic "automatic_scaling" {
    for_each = {
      for k, v in each.value : k => v
      if k == "automatic_scaling"
    }
    content {
      max_concurrent_requests = lookup(automatic_scaling.value, "max_concurrent_requests", null)
      max_idle_instances      = lookup(automatic_scaling.value, "max_idle_instances", null)
      max_pending_latency     = lookup(automatic_scaling.value, "max_pending_latency", null)
      min_idle_instances      = lookup(automatic_scaling.value, "min_idle_instances", null)
      min_pending_latency     = lookup(automatic_scaling.value, "min_pending_latency", null)
      dynamic "standard_scheduler_settings" {
        for_each = {
          for k, v in automatic_scaling.value : k => v
          if k == "standard_scheduler_settings"
        }
        content {
          target_cpu_utilization        = lookup(standard_scheduler_settings.value, "target_cpu_utilization", null)
          target_throughput_utilization = lookup(standard_scheduler_settings.value, "target_throughput_utilization", null)
          min_instances                 = lookup(standard_scheduler_settings.value, "min_instances", null)
          max_instances                 = lookup(standard_scheduler_settings.value, "max_instances", null)
        }
      }

    }
  }

  dynamic "basic_scaling" {
    for_each = {
      for k, v in each.value : k => v
      if k == "basic_scaling"
    }
    content {
      idle_timeout  = lookup(basic_scaling.value, "idle_timeout", null)
      max_instances = lookup(basic_scaling.value, "max_instances", null)
    }
  }

  dynamic "deployment" {
    for_each = {
      for k, v in each.value : k => v
      if k == "deployment"
    }
    content {

      dynamic "files" {
        for_each = {
          for k, v in deployment.value : k => v
          if k == "files"
        }
        content {
          name       = lookup(files.value, "name", null)
          source_url = lookup(files.value, "source_url", null)
        }
      }

      dynamic "zip" {
        for_each = {
          for k, v in deployment.value : k => v
          if k == "zip"
        }
        content {
          files_count = lookup(zip.value, "files_count", null)
          source_url  = lookup(zip.value, "source_url", null)
        }
      }

    }
  }

  dynamic "entrypoint" {
    for_each = {
      for k, v in each.value : k => v
      if k == "entrypoint"
    }
    content {
      shell = lookup(entrypoint.value, "shell", null)
    }
  }

  dynamic "handlers" {
    for_each = {
      for k, v in each.value : k => v
      if k == "handlers"
    }
    content {
      auth_fail_action            = lookup(handlers.value, "auth_fail_action", null)
      login                       = lookup(handlers.value, "login", null)
      redirect_http_response_code = lookup(handlers.value, "redirect_http_response_code", null)
      security_level              = lookup(handlers.value, "security_level", null)
      url_regex                   = lookup(handlers.value, "url_regex", null)

      dynamic "script" {
        for_each = {
          for k, v in handlers.value : k => v
          if k == "script"
        }
        content {
          script_path = lookup(script.value, "script_path", null)
        }
      }

      dynamic "static_files" {
        for_each = {
          for k, v in handlers.value : k => v
          if k == "static_files"
        }
        content {
          application_readable  = lookup(static_files.value, "application_readable", null)
          expiration            = lookup(static_files.value, "expiration", null)
          http_headers          = lookup(static_files.value, "http_headers", null)
          mime_type             = lookup(static_files.value, "mime_type", null)
          path                  = lookup(static_files.value, "path", null)
          require_matching_file = lookup(static_files.value, "require_matching_file", null)
          upload_path_regex     = lookup(static_files.value, "upload_path_regex", null)
        }
      }

    }
  }

  dynamic "libraries" {
    for_each = {
      for k, v in each.value : k => v
      if k == "libraries"
    }
    content {
      name    = lookup(libraries.value, "name", null)
      version = lookup(libraries.value, "version", null)
    }
  }

  dynamic "manual_scaling" {
    for_each = {
      for k, v in each.value : k => v
      if k == "manual_scaling"
    }
    content {
      instances = lookup(manual_scaling.value, "instances", null)
    }
  }

  dynamic "timeouts" {
    for_each = {
      for k, v in each.value : k => v
      if k == "timeouts"
    }
    content {
      create = lookup(timeouts.value, "create", null)
      delete = lookup(timeouts.value, "delete", null)
      update = lookup(timeouts.value, "update", null)
    }
  }

  dynamic "vpc_access_connector" {
    for_each = {
      for k, v in each.value : k => v
      if k == "vpc_access_connector"
    }
    content {
      name = lookup(vpc_access_connector.value, "name", null)
    }
  }

}