resource "google_app_engine_flexible_app_version" "appengine_flexible" {
  for_each = {
    for k, v in var.flexible_app_versions : k => v
    if v.create
  }
  beta_settings                = lookup(each.value, "beta_settings", null)
  default_expiration           = lookup(each.value, "default_expiration", null)
  delete_service_on_destroy    = lookup(each.value, "delete_service_on_destroy", null)
  env_variables                = lookup(each.value, "env_variables", null)
  inbound_services             = lookup(each.value, "inbound_services", null)
  instance_class               = lookup(each.value, "instance_class", null)
  nobuild_files_regex          = lookup(each.value, "nobuild_files_regex", null)
  noop_on_destroy              = lookup(each.value, "noop_on_destroy", null)
  project                      = format("%s", var.project_id)
  runtime                      = lookup(each.value, "runtime", null)
  runtime_api_version          = lookup(each.value, "runtime_api_version", null)
  runtime_channel              = lookup(each.value, "runtime_channel", null)
  runtime_main_executable_path = lookup(each.value, "runtime_channel", null)
  service                      = format("%s", each.key)
  service_account              = data.google_service_account.appengine_flexible[each.key].name
  serving_status               = lookup(each.value, "runtime_channel", null)
  version_id                   = lookup(each.value, "version_id", null)

  dynamic "api_config" {
    for_each = { for k, v in each.value : k => v if k == "api_config" }
    content {
      auth_fail_action = lookup(api_config.value, "auth_fail_action", null)
      login            = lookup(api_config.value, "login", null)
      script           = lookup(api_config.value, "script", null)
      security_level   = lookup(api_config.value, "security_level", null)
      url              = lookup(api_config.value, "url", null)
    }
  }

  dynamic "automatic_scaling" {
    for_each = { for k, v in each.value : k => v if k == "automatic_scaling" }
    content {
      cool_down_period        = lookup(automatic_scaling.value, "cool_down_period", null)
      max_concurrent_requests = lookup(automatic_scaling.value, "max_concurrent_requests", null)
      max_idle_instances      = lookup(automatic_scaling.value, "max_idle_instances", null)
      max_pending_latency     = lookup(automatic_scaling.value, "max_pending_latency", null)
      max_total_instances     = lookup(automatic_scaling.value, "max_total_instances", null)
      min_idle_instances      = lookup(automatic_scaling.value, "min_idle_instances", null)
      min_pending_latency     = lookup(automatic_scaling.value, "min_pending_latency", null)
      min_total_instances     = lookup(automatic_scaling.value, "min_total_instances", null)

      dynamic "cpu_utilization" {
        for_each = {
          for k, v in automatic_scaling.value : k => v
          if k == "cpu_utilization"
        }
        content {
          aggregation_window_length = lookup(cpu_utilization.value, "aggregation_window_length", null)
          target_utilization        = lookup(cpu_utilization.value, "target_utilization", null)
        }
      }

      dynamic "disk_utilization" {
        for_each = {
          for k, v in automatic_scaling.value : k => v
          if k == "disk_utilization"
        }
        content {
          target_read_bytes_per_second  = lookup(disk_utilization.value, "target_read_bytes_per_second", null)
          target_read_ops_per_second    = lookup(disk_utilization.value, "target_read_ops_per_second", null)
          target_write_bytes_per_second = lookup(disk_utilization.value, "target_write_bytes_per_second", null)
          target_write_ops_per_second   = lookup(disk_utilization.value, "target_write_ops_per_second", null)
        }
      }

      dynamic "network_utilization" {
        for_each = {
          for k, v in automatic_scaling.value : k => v
          if k == "network_utilization"
        }
        content {
          target_received_bytes_per_second   = lookup(network_utilization.value, "target_received_bytes_per_second", null)
          target_received_packets_per_second = lookup(network_utilization.value, "target_received_packets_per_second", null)
          target_sent_bytes_per_second       = lookup(network_utilization.value, "target_sent_bytes_per_second", null)
          target_sent_packets_per_second     = lookup(network_utilization.value, "target_sent_packets_per_second", null)
        }
      }

      dynamic "request_utilization" {
        for_each = {
          for k, v in automatic_scaling.value : k => v
          if k == "request_utilization"
        }
        content {
          target_concurrent_requests      = lookup(request_utilization.value, "target_concurrent_requests", null)
          target_request_count_per_second = lookup(request_utilization.value, "target_request_count_per_second", null)
        }
      }

    }
  }

  dynamic "deployment" {
    for_each = { for k, v in each.value : k => v if k == "deployment" }
    content {

      dynamic "cloud_build_options" {
        for_each = {
          for k, v in deployment.value : k => v
          if k == "cloud_build_options"
        }
        content {
          app_yaml_path       = lookup(cloud_build_options.value, "app_yaml_path", null)
          cloud_build_timeout = lookup(cloud_build_options.value, "cloud_build_timeout", null)
        }
      }

      dynamic "container" {
        for_each = {
          for k, v in deployment.value : k => v
          if k == "container"
        }
        content {
          image = lookup(container.value, "image", null)
        }
      }

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

  dynamic "endpoints_api_service" {
    for_each = { for k, v in each.value : k => v if k == "endpoints_api_service" }
    content {
      config_id              = lookup(endpoints_api_service.value, "config_id", null)
      disable_trace_sampling = lookup(endpoints_api_service.value, "disable_trace_sampling", null)
      name                   = lookup(endpoints_api_service.value, "name", null)
      rollout_strategy       = lookup(endpoints_api_service.value, "rollout_strategy", null)
    }
  }

  dynamic "entrypoint" {
    for_each = { for k, v in each.value : k => v if k == "entrypoint" }
    content {
      shell = lookup(entrypoint.value, "shell", null)
    }
  }

  dynamic "handlers" {
    for_each = { for k, v in each.value : k => v if k == "handlers" }
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

  dynamic "liveness_check" {
    for_each = { for k, v in each.value : k => v if k == "liveness_check" }
    content {
      check_interval    = lookup(liveness_check.value, "check_interval", null)
      failure_threshold = lookup(liveness_check.value, "failure_threshold", null)
      host              = lookup(liveness_check.value, "host", null)
      initial_delay     = lookup(liveness_check.value, "initial_delay", null)
      path              = lookup(liveness_check.value, "path", null)
      success_threshold = lookup(liveness_check.value, "success_threshold", null)
      timeout           = lookup(liveness_check.value, "timeout", null)
    }
  }

  dynamic "manual_scaling" {
    for_each = { for k, v in each.value : k => v if k == "manual_scaling" }
    content {
      instances = lookup(manual_scaling.value, "instances", null)
    }
  }

  dynamic "network" {
    for_each = { for k, v in each.value : k => v if k == "network" }
    content {
      forwarded_ports  = lookup(network.value, "forwarded_ports", null)
      instance_tag     = lookup(network.value, "instance_tag", null)
      name             = lookup(network.value, "name", null)
      session_affinity = lookup(network.value, "session_affinity", null)
      subnetwork       = lookup(network.value, "subnetwork", null)
    }
  }

  dynamic "readiness_check" {
    for_each = { for k, v in each.value : k => v if k == "readiness_check" }
    content {
      app_start_timeout = lookup(readiness_check.value, "app_start_timeout", null)
      check_interval    = lookup(readiness_check.value, "check_interval", null)
      failure_threshold = lookup(readiness_check.value, "failure_threshold", null)
      host              = lookup(readiness_check.value, "host", null)
      path              = lookup(readiness_check.value, "path", null)
      success_threshold = lookup(readiness_check.value, "success_threshold", null)
      timeout           = lookup(readiness_check.value, "timeout", null)
    }
  }

  dynamic "resources" {
    for_each = { for k, v in each.value : k => v if k == "resources" }
    content {
      cpu       = lookup(readiness_check.value, "cpu", null)
      disk_gb   = lookup(readiness_check.value, "disk_gb", null)
      memory_gb = lookup(readiness_check.value, "memory_gb", null)

      dynamic "volumes" {
        for_each = {
          for k, v in resources.value : k => v
          if k == "volumes"
        }
        content {
          name        = lookup(static_files.value, "name", null)
          size_gb     = lookup(static_files.value, "size_gb", null)
          volume_type = lookup(static_files.value, "volume_type", null)
        }
      }

    }
  }

  dynamic "timeouts" {
    for_each = { for k, v in each.value : k => v if k == "timeouts" }
    content {
      create = lookup(timeouts.value, "create", null)
      delete = lookup(timeouts.value, "delete", null)
      update = lookup(timeouts.value, "update", null)
    }
  }

  dynamic "vpc_access_connector" {
    for_each = { for k, v in each.value : k => v if k == "vpc_access_connector" }
    content {
      name = lookup(vpc_access_connector.value, "name", null)
    }
  }

}