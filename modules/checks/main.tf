# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# UPTIME CHECKS
# Submodule for creating the uptime checks.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM CONFIGURATION
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.0.0"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# UPTIME CHECKS
# ---------------------------------------------------------------------------------------------------------------------

resource "google_monitoring_uptime_check_config" "checks" {
  for_each         = { for check in var.checks : lower(check.display_name) => check }
  display_name     = each.value.display_name
  project          = var.project_id
  timeout          = each.value.timeout
  period           = each.value.period
  selected_regions = each.value.selected_regions

  dynamic "content_matchers" {
    for_each = lookup(each.value, "content_matchers") == null ? [] : [each.value.content_matchers]
    content {
      content = lookup(content_matchers.value, "content", null)
      matcher = lookup(content_matchers.value, "matcher", null)
    }
  }

  dynamic "http_check" {
    for_each = lookup(each.value, "http_check") == null ? [] : [each.value.http_check]
    content {
      request_method = lookup(http_check.value, "request_method", "GET")
      content_type   = lookup(http_check.value, "content_type", null)
      port           = lookup(http_check.value, "port", 80)
      headers        = lookup(http_check.value, "headers", null)
      path           = lookup(http_check.value, "path", "/")
      use_ssl        = lookup(http_check.value, "use_ssl", false)
      validate_ssl   = lookup(http_check.value, "validate_ssl", false)
      mask_headers   = lookup(http_check.value, "mask_headers", null)
      body           = lookup(http_check.value, "body", null)
      dynamic "auth_info" {
        for_each = lookup(http_check.value, "auth_info", null) == null ? [] : [http_check.value.auth_info]
        content {
          password = auth_info.value.password
          username = auth_info.value.username
        }
      }
    }
  }

  dynamic "tcp_check" {
    for_each = lookup(each.value, "tcp_check") == null ? [] : [each.value.tcp_check]
    content {
      port = lookup(tcp_check.value, "port", null)
    }
  }

  dynamic "resource_group" {
    for_each = lookup(each.value, "resource_group") == null ? [] : [each.value.resource_group]
    content {
      resource_type = lookup(resource_group.value, "resource_type", null)
      group_id      = lookup(resource_group.value, "group_id", null)
    }
  }

  dynamic "monitored_resource" {
    for_each = lookup(each.value, "monitored_resource") == null ? [] : [each.value.monitored_resource]
    content {
      type     = lookup(monitored_resource.value, "type", null)
      labels   = lookup(monitored_resource.value, "labels", null)
    }
  }
}
