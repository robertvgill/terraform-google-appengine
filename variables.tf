## access token
variable "google_access_token_file" {
  description = "Google Cloud access token file."
  type        = string
  sensitive   = true
}

## appengine
variable "app_engine_create" {
  description = "Boolean flag which forces App Engine is created and use it for all resources."
  type        = bool
}

variable "project_id" {
  description = "(Required) The project ID to create the application under. ~>NOTE: GCP only accepts project ID, not project number. If you are using number, you may get a `Permission denied` error."
  type        = string
  default     = ""
}

variable "location_id" {
  description = "(Required) The location to serve the app from."
  type        = string
  default     = ""
}

variable "auth_domain" {
  description = "(Optional) The domain to authenticate users with when using App Engine's User API."
  type        = string
  default     = null
}

variable "database_type" {
  description = "(Optional) The type of the Cloud Firestore or Cloud Datastore database associated with this application. Can be `CLOUD_FIRESTORE` or `CLOUD_DATASTORE_COMPATIBILITY` for new instances."
  type        = string
  default     = null

  validation {
    condition     = var.database_type == null || contains(["CLOUD_FIRESTORE", "CLOUD_DATASTORE_COMPATIBILITY"], var.database_type == null ? "" : var.database_type)
    error_message = "The database type must be one of [CLOUD_FIRESTORE, CLOUD_DATASTORE_COMPATIBILITY]."
  }
}

variable "serving_status" {
  description = "(Optional) The serving status of the app."
  type        = string
  default     = null

  validation {
    condition     = var.serving_status == null || contains(["UNSPECIFIED", "SERVING", "USER_DISABLED", "SYSTEM_DISABLED"], var.serving_status == null ? "" : var.serving_status)
    error_message = "The serving status of the app must be one of [UNSPECIFIED, SERVING, USER_DISABLED, SYSTEM_DISABLED]."
  }
}

variable "feature_settings" {
  description = "(Optional) A block of optional settings to configure specific App Engine features."
  type = object({
    split_health_checks = bool
  })
  default = null
}

variable "iap" {
  description = "(Optional) Settings for enabling Cloud Identity Aware Proxy."
  type = object({
    oauth2_client_id     = string,
    oauth2_client_secret = string
  })
  default = null
}

variable "firewall_rules" {
  description = "Rules of the App Engine Firewall to create."
  default     = {}
}

## appengine standard
variable "app_engine_standard_create" {
  description = "Boolean flag which forces App Engine standard is created and use it for all resources."
  type        = bool
}

variable "service_version" {
  description = "(Optional) Name of the App Engine version of the Service that will be deployed."
  type        = string
  default     = null

  validation {
    condition     = var.service_version == null || length(var.service_version == null ? "" : var.service_version) > 0 && length(var.service_version == null ? "" : var.service_version) < 63
    error_message = "The version name can't be empty and the length cannot exceed 63 characters."
  }
}

variable "service" {
  description = "(Required; Default: default) Name of the App Engine Service"
  type        = string
  default     = "default"

  validation {
    condition     = length(var.service) > 0 && length(var.service) < 63
    error_message = "The Service name can't be null and the length cannot exceed 63 characters."
  }
}

variable "runtime" {
  description = "(Required; Default: python27) The runtime that will be used by App Engine. Supported runtimes are: python27, python37, python38, java8, java11, php55, php73, php74, ruby25, go111, go112, go113, go114, nodejs10, nodejs12."
  type        = string
  default     = "python27"

  validation {
    condition     = contains(["python27", "python37", "python38", "java8", "java11", "php55", "php73", "php74", "ruby25", "go111", "go112", "go113", "go114", "nodejs10", "nodejs12"], var.runtime)
    error_message = "The specified runtime does not match any of the supported runtimes: \n - Python: python27, python37, python38 \n - Java: java8, java11 \n - PHP: php55, php73, php74 \n - Ruby: ruby25 \n - Go: go111, go112, go113, go114 \n - Node.js: nodejs10, nodejs12."
  }
}

variable "threadsafe" {
  description = "(Optional; Default True) Whether the application should use concurrent requests or not. Only appliable for python27 and java8 runtimes."
  type        = bool
  default     = true
}

variable "api_version" {
  description = "(Optional)The version of the API in the given runtime environment that is used by your app. The field is deprecated for newer App Engine runtimes."
  type        = number
  default     = null
}

variable "env_variables" {
  description = "(Optional) Environment variables to be passed to the App Engine service"
  type        = map(any)
  default     = {}
}

variable "noop_on_destroy" {
  description = "(Optional; Default: True) If set to true, the application version will not be deleted upon running Terraform destroy."
  type        = bool
  default     = true
}

variable "delete_service_on_destroy" {
  description = "(Optional; Default: False) If set to true, the service will be deleted if it is the last version."
  type        = bool
  default     = false
}

variable "instance_class" {
  description = "(Optional; Default: F1) Instance class that is used to run this version. Valid values are AutomaticScaling: F1, F2, F4, F4_1G BasicScaling or ManualScaling: B1, B2, B4, B4_1G, B8 Defaults to F1 for AutomaticScaling and B2 for ManualScaling and BasicScaling. If no scaling is specified, AutomaticScaling is chosen."
  type        = string
  default     = "F1"

  validation {
    condition     = contains(["B1", "B2", "B4", "B4_1G", "B8", "F1", "F2", "F4", "F4_1G"], var.instance_class)
    error_message = "Instance class must be one of [B1, B2, B4, B4_1G, B8] for BasicScaling or ManualScaling and one of [F1, F2, F4, F4_1G] for AutomaticScaling."
  }
}

variable "inbound_services" {
  description = "(Optional) A list of the types of messages that this application is able to receive."
  type        = list(string)
  default     = null

  validation {
    condition     = var.inbound_services == null || contains(["INBOUND_SERVICE_MAIL", "INBOUND_SERVICE_MAIL_BOUNCE", "INBOUND_SERVICE_XMPP_ERROR", "INBOUND_SERVICE_XMPP_MESSAGE", "INBOUND_SERVICE_XMPP_SUBSCRIBE", "INBOUND_SERVICE_XMPP_PRESENCE", "INBOUND_SERVICE_CHANNEL_PRESENCE", "INBOUND_SERVICE_WARMUP"], (var.inbound_services == null ? [] : var.inbound_services))
    error_message = "Inbound services must be a list with any of the following values [INBOUND_SERVICE_MAIL, INBOUND_SERVICE_MAIL_BOUNCE, INBOUND_SERVICE_XMPP_ERROR, INBOUND_SERVICE_XMPP_MESSAGE, INBOUND_SERVICE_XMPP_SUBSCRIBE, INBOUND_SERVICE_XMPP_PRESENCE, INBOUND_SERVICE_CHANNEL_PRESENCE, INBOUND_SERVICE_WARMUP]."
  }
}

variable "zip" {
  description = "(Optional) Zip File Structure."
  type = object({
    source_url  = string,
    files_count = number
  })
  default = null
}

variable "files" {
  description = "(Optional) Manifest of the files stored in Google Cloud Storage that are included as part of this version."
  type = list(object({
    name       = string,
    sha1_sum   = string,
    source_url = string
  }))
  default = null
}

variable "handlers" {
  description = "(Optional) An ordered list of URL-matching patterns that should be applied to incoming requests. The first matching URL handles the request and other request handlers are not attempted."
  type = list(object({
    url_regex                   = string,
    security_level              = string,
    login                       = string,
    auth_fail_action            = string,
    redirect_http_response_code = string,
    script = object({
      script_path = string
    })
    static_files = object({
      path                  = string,
      upload_path_regex     = string,
      http_headers          = map(string),
      mime_type             = string,
      expiration            = string,
      require_matching_file = bool,
      application_readable  = bool
    })
  }))

  validation {
    condition     = var.handlers != null ? !contains([for security_level in var.handlers[*].security_level : (security_level == null || contains(["SECURE_DEFAULT", "SECURE_NEVER", "SECURE_OPTIONAL", "SECURE_ALWAYS"], security_level)) if security_level != null], false) : true
    error_message = "Security level field value must be one of [SECURE_DEFAULT, SECURE_NEVER, SECURE_OPTIONAL, SECURE_ALWAYS]."
  }
  validation {
    condition     = var.handlers != null ? !contains([for login in var.handlers[*].login : (login == null || contains(["LOGIN_OPTIONAL", "LOGIN_ADMIN", "LOGIN_REQUIRED"], login)) if login != null], false) : true
    error_message = "Login field value must be one of [LOGIN_OPTIONAL, LOGIN_ADMIN, LOGIN_REQUIRED]."
  }
  validation {
    condition     = var.handlers != null ? !contains([for auth_fail_action in var.handlers[*].auth_fail_action : (auth_fail_action == null || contains(["AUTH_FAIL_ACTION_REDIRECT", "AUTH_FAIL_ACTION_UNAUTHORIZED"], auth_fail_action)) if auth_fail_action != null], false) : true
    error_message = "Auth fail action field value must be one of [AUTH_FAIL_ACTION_REDIRECT,AUTH_FAIL_ACTION_UNAUTHORIZED]."
  }
  validation {
    condition     = var.handlers != null ? !contains([for redirect_http_response_code in var.handlers[*].redirect_http_response_code : (redirect_http_response_code == null || contains(["REDIRECT_HTTP_RESPONSE_CODE_301", "REDIRECT_HTTP_RESPONSE_CODE_302", "REDIRECT_HTTP_RESPONSE_CODE_303", "REDIRECT_HTTP_RESPONSE_CODE_307"], redirect_http_response_code)) if redirect_http_response_code != null], false) : true
    error_message = "Redirect HTTP response code field value must be one of [REDIRECT_HTTP_RESPONSE_CODE_301, REDIRECT_HTTP_RESPONSE_CODE_302, REDIRECT_HTTP_RESPONSE_CODE_303, REDIRECT_HTTP_RESPONSE_CODE_307]."
  }
  default = null
}

variable "libraries" {
  description = "(Optional) Configuration for third-party Python runtime libraries that are required by the application."
  type = list(object({
    name    = string,
    version = string
  }))
  default = null
}

variable "entrypoint" {
  description = "(Optional) The entrypoint for the application."
  type = object({
    shell = string
  })
  default = null
}

variable "automatic_scaling_standard" {
  description = "(Optional) Automatic scaling of the App Engine standard is based on request rate, response latencies, and other application metrics."
  type = object({
    create                  = bool,
    max_concurrent_requests = number,
    max_idle_instances      = number,
    max_pending_latency     = string,
    min_idle_instances      = number,
    min_pending_latency     = string
    standard_scheduler_settings = object({
      target_cpu_utilization        = number,
      target_throughput_utilization = number,
      min_instances                 = number,
      max_instances                 = number
    })
  })
  default = {
    create                  = false,
    max_concurrent_requests = 10,
    max_idle_instances      = 10,
    max_pending_latency     = "30ms",
    min_idle_instances      = 3,
    min_pending_latency     = "0s",
    standard_scheduler_settings = {
      target_cpu_utilization        = 0.6,
      target_throughput_utilization = 0.6,
      min_instances                 = 0,
      max_instances                 = 1
    }
  }

  validation {
    condition     = !contains([for max_concurrent_requests in var.automatic_scaling_standard[*].max_concurrent_requests : (max_concurrent_requests >= 10 && max_concurrent_requests <= 80)], false)
    error_message = "The value of max_concurrent_requests must fall within range [10, 80]."
  }
  validation {
    condition     = !contains([for max_idle_instances in var.automatic_scaling_standard[*].max_idle_instances : (max_idle_instances >= 1 && max_idle_instances <= 1000)], false)
    error_message = "The value of max_idle_instances needs to fall within range [1, 1000]."
  }
  validation {
    condition     = !contains([for min_idle_instances in var.automatic_scaling_standard[*].min_idle_instances : (min_idle_instances >= 1 && min_idle_instances <= 1000)], false)
    error_message = "The value of min_idle_instances needs to be fall within range [1, 1000]."
  }
  validation {
    condition     = !contains([for standard_scheduler_settings in var.automatic_scaling_standard[*].standard_scheduler_settings : contains([for target_cpu_utilization in standard_scheduler_settings[*].target_cpu_utilization : (target_cpu_utilization >= 0.5 && target_cpu_utilization <= 0.95)], false)], true)
    error_message = "The target_cpu_utilization value must fall within range [0.5, 0.95]."
  }
  validation {
    condition     = !contains([for standard_scheduler_settings in var.automatic_scaling_standard[*].standard_scheduler_settings : contains([for target_throughput_utilization in standard_scheduler_settings[*].target_throughput_utilization : (target_throughput_utilization >= 0.5 && target_throughput_utilization <= 0.95)], false)], true)
    error_message = "The target_throughput_utilization value must fall within range [0.5, 0.95]."
  }
  validation {
    condition     = !contains([for standard_scheduler_settings in var.automatic_scaling_standard[*].standard_scheduler_settings : contains([for min_instances in standard_scheduler_settings[*].target_throughput_utilization : (min_instances >= 0 && min_instances <= 1000)], false)], true)
    error_message = "The min_instances value must fall within range [0,1000]."
  }
  validation {
    condition     = !contains([for standard_scheduler_settings in var.automatic_scaling_standard[*].standard_scheduler_settings : contains([for max_instances in standard_scheduler_settings[*].target_throughput_utilization : (max_instances >= 0 && max_instances <= 1000)], false)], true)
    error_message = "The max_instances value must fall within range [0,2147483647]."
  }
}

variable "basic_scaling_standard" {
  description = "(Optional) Basic scaling."
  type = object({
    create        = bool,
    idle_timeout  = string,
    max_instances = number,
  })
  default = {
    create        = false,
    idle_timeout  = "30s",
    max_instances = 5
  }
}

variable "manual_scaling_standard" {
  description = "(Optional) Manual scaling."
  type = object({
    create    = bool,
    instances = number,
  })
  default = {
    create    = false,
    instances = 5,
  }
}

variable "vpc_access_connector" {
  description = "(Optional) Enables VPC connectivity for standard apps."
  type = object({
    name = string
  })
  default = null

  validation {
    condition     = var.vpc_access_connector != null ? length(regexall("^\\bprojects\\b/[[:word:]-]+/\\blocations\\b/[[:word:]-]+/\\bconnectors\\b/[[:word:]-]+$", (var.vpc_access_connector.name == null ? "" : var.vpc_access_connector.name))) > 0 : true
    error_message = "Format of VPC access connector must use the following format `projects/[$PROJECT_NAME]/locations/[$CONNECTOR_LOCATION]/connectors/[$CONNECTOR_NAME]`."
  }
}

## appengine flexible
variable "app_engine_flexible_create" {
  description = "Boolean flag which forces App Engine standard is created and use it for all resources."
  type        = bool
}

variable "readiness_path" {
  description = "(Required; Default `/readiness`) The request path."
  type        = string
  default     = "/readiness"
}

variable "readiness_host" {
  description = "(Optional) Host header to send when performing a HTTP Readiness check."
  type        = string
  default     = null
}

variable "readiness_failure_threshold" {
  description = "(Optional; Default 2) Number of consecutive failed checks required before removing traffic."
  type        = number
  default     = 2
}

variable "readiness_success_threshold" {
  description = "(Optional; Default 2) Number of consecutive successful checks required before receiving traffic."
  type        = number
  default     = 2
}

variable "readiness_check_interval" {
  description = "(Optional; Default `5s`) Interval between health checks."
  type        = string
  default     = "5s"
}

variable "readiness_timeout" {
  description = "(Optional; Default `4s`) Time before the check is considered failed."
  type        = string
  default     = "4s"
}

variable "readiness_app_start_timeout" {
  description = "(Optional; Default `300s`) A maximum time limit on application initialization, measured from moment the application successfully replies to a healthcheck until it is ready to serve traffic."
  type        = string
  default     = "300s"
}

variable "liveness_path" {
  description = "(Required; Default `/liveness`) The request path."
  type        = string
  default     = "/liveness"
}

variable "liveness_host" {
  description = "(Optional) Host header to send when performing a HTTP Readiness check."
  type        = string
  default     = null
}

variable "liveness_failure_threshold" {
  description = "(Optional; Default 4) Number of consecutive failed checks required before removing traffic."
  type        = number
  default     = 4
}

variable "liveness_success_threshold" {
  description = "(Optional; Default 2) Number of consecutive successful checks required before receiving traffic."
  type        = number
  default     = 2
}

variable "liveness_check_interval" {
  description = "(Optional; Default `30s`) Interval between health checks."
  type        = string
  default     = "30ss"
}

variable "liveness_timeout" {
  description = "(Optional; Default `4s`) Time before the check is considered failed."
  type        = string
  default     = "4s"
}

variable "liveness_initial_delay" {
  description = "(Optional; Default `300s`) A maximum time limit on application initialization, measured from moment the application successfully replies to a healthcheck until it is ready to serve traffic."
  type        = string
  default     = "300s"
}

variable "network" {
  description = "(Optional) Extra network settings to be defined for the App Engine service."
  type = object({
    forwarded_ports  = list(string),
    instance_tag     = string,
    name             = string,
    subnetwork       = string,
    session_affinity = bool
  })
  default = null
}

variable "resources" {
  description = "(Optional) Machine resources for a version."
  type = object({
    cpu       = number,
    disk_gb   = number,
    memory_gb = number,
    volumes = list(object({
      name        = string,
      volume_type = string,
      size_gb     = number
    }))
  })
  default = null

  validation {
    condition     = var.resources != null ? (var.resources.cpu == 1 || (var.resources.cpu >= 2 && var.resources.cpu <= 96 && var.resources.cpu / 2 == 0)) : true
    error_message = "CPU must be 1 or an even number between 2 and 96."
  }

  validation {
    condition     = var.resources != null ? (var.resources.disk_gb >= 10 && var.resources.disk_gb <= 10240) : true
    error_message = "Disk size must be between 10GB and 10240GB."
  }

  validation {
    condition     = var.resources != null ? (var.resources.volumes != null ? length(var.resources.volumes["name"]) >= 1 && length(var.resources.volumes["name"]) <= 63 && length(regexall("^[A-z][[:word:]-]+[[:alnum:]]$", var.resources.volumes["name"])) > 0 : true) : true
    error_message = "Volume name length must be between 1 and 63. The first character has to be a letter and the last character can't be a dash."
  }

  validation {
    condition     = var.resources != null ? (var.resources.volumes != null ? var.resources.volumes["volume_type"] == "tmfps" : true) : true
    error_message = "Volume type must be tmfps."
  }
}

variable "runtime_channel" {
  description = "(Optional) The channel of the runtime to use. Only available for some runtimes."
  type        = string
  default     = null
}

variable "beta_settings" {
  description = "(Optional) Metadata settings that are supplied to this version to enable beta runtime features."
  type        = map(any)
  default     = null
}

variable "runtime_main_executable_path" {
  description = "(Optional) The path or name of the app's main executable."
  type        = string
  default     = null
}

variable "api_config" {
  description = "(Optional) Serving configuration for Google Cloud Endpoints."
  type = list(object({
    auth_fail_action = string,
    login            = string,
    script           = string,
    security_level   = string,
    url              = string
  }))
  default = null

  validation {
    condition     = var.api_config != null ? !contains([for auth_fail_action in var.api_config[*].auth_fail_action : (auth_fail_action == null || contains(["AUTH_FAIL_ACTION_REDIRECT", "AUTH_FAIL_ACTION_UNAUTHORIZED"], auth_fail_action)) if auth_fail_action != null], false) : true
    error_message = "Auth fail action field value must be one of [AUTH_FAIL_ACTION_REDIRECT,AUTH_FAIL_ACTION_UNAUTHORIZED]."
  }

  validation {
    condition     = var.api_config != null ? !contains([for login in var.api_config[*].login : (login == null || contains(["LOGIN_OPTIONAL", "LOGIN_ADMIN", "LOGIN_REQUIRED"], login)) if login != null], false) : true
    error_message = "Login field value must be one of [LOGIN_OPTIONAL, LOGIN_ADMIN, LOGIN_REQUIRED]."
  }

  validation {
    condition     = var.api_config != null ? !contains([for security_level in var.api_config[*].security_level : (security_level == null || contains(["SECURE_DEFAULT", "SECURE_NEVER", "SECURE_OPTIONAL", "SECURE_ALWAYS"], security_level)) if security_level != null], false) : true
    error_message = "Security level field value must be one of [SECURE_DEFAULT, SECURE_NEVER, SECURE_OPTIONAL, SECURE_ALWAYS]."
  }
}

variable "default_expiration" {
  description = "(Optional) Duration that static files should be cached by web proxies and browsers. Only applicable if the corresponding StaticFilesHandler does not specify its own expiration time."
  type        = string
  default     = null
}

variable "nobuild_files_regex" {
  description = "(Optional) Files that match this pattern will not be built into this version. Only applicable for Go runtimes."
  type        = string
  default     = null
}

variable "container" {
  description = "(Optional) The Docker image for the container that runs the version."
  type = list(object({
    image = string
  }))
  default = null

  validation {
    condition     = var.container != null ? !contains([for image in var.container[*].image : (image == null || length(regexall("^(eu|us|asia)?gcr.io/[[:word:]-]+/[[:word:]-]+(:[[:word:]-]+|@[[:alnum:]]+)$", image)) > 0) if image != null], false) : true
    error_message = "Security level field value must be one of [SECURE_DEFAULT, SECURE_NEVER, SECURE_OPTIONAL, SECURE_ALWAYS]."
  }
}

variable "cloud_build_options" {
  description = "(Optional) Options for the build operations performed as a part of the version deployment. Only applicable when creating a version using source code directly."
  type = list(object({
    app_yaml_path       = string
    cloud_build_timeout = string
  }))
  default = null
}

variable "endpoints_api_service" {
  description = "(Optional) Code and application artifacts that make up this version."
  type = list(object({
    name                   = string
    config_id              = string
    rollout_strategy       = string
    disable_trace_sampling = bool
  }))
  default = null

  validation {
    condition     = var.endpoints_api_service != null ? !contains([for rollout_strategy in var.endpoints_api_service[*].rollout_strategy : (rollout_strategy == null || contains(["FIXED", "MANAGED"], rollout_strategy)) if rollout_strategy != null], false) : true
    error_message = "Rollout strategy field value must be one of [FIXED, MANAGED]."
  }
}

variable "automatic_scaling_flexible" {
  description = "(Optional) Automatic scaling of the App Engine flexible."
  type = object({
    create           = bool,
    cool_down_period = string
    cpu_utilization = object({
      aggregation_window_length = optional(number),
      target_utilization        = number
    }),
    max_concurrent_requests = optional(number),
    max_idle_instances      = optional(number),
    max_total_instances     = optional(number),
    max_pending_latency     = optional(string),
    min_idle_instances      = optional(number),
    min_total_instances     = optional(number),
    min_pending_latency     = optional(string),
    request_utilization = optional(object({
      target_request_count_per_second = number,
      target_concurrent_requests      = string
    })),
    disk_utilization = optional(object({
      target_read_bytes_per_second  = optional(number),
      target_read_ops_per_second    = optional(number),
      target_write_bytes_per_second = optional(number),
      target_write_ops_per_second   = optional(number)
    })),
    network_utilization = optional(object({
      target_received_bytes_per_second   = optional(number),
      target_received_packets_per_second = optional(number),
      target_sent_bytes_per_second       = optional(number),
      target_sent_packets_per_second     = optional(number)
    })),
  })
  default = null

  validation {
    condition     = !contains([for cpu_utilization in var.automatic_scaling_flexible[*].cpu_utilization : contains([for target_utilization in cpu_utilization[*].target_utilization : (target_utilization > 0 && target_utilization <= 1)], false)], true)
    error_message = "Target utilization value must be between 0 and 1."
  }
}

variable "manual_scaling_flexible" {
  description = "(Optional) Manual scaling."
  type = object({
    create    = bool,
    instances = number,
  })
  default = {
    create    = false,
    instances = 5,
  }
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}