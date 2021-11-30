# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ALERT POLICIES
# Submodule for creating the alert policies.
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
# ALERT POLICIES
# ---------------------------------------------------------------------------------------------------------------------

resource "google_monitoring_alert_policy" "policies" {
  for_each              = { for policy in var.policies : policy.display_name => policy }
  display_name          = each.value.display_name
  project               = var.project_id
  combiner              = each.value.combiner
  enabled               = each.value.enabled
  notification_channels = each.value.notification_channels
  user_labels           = each.value.user_labels

  dynamic "documentation" {
    for_each = lookup(each.value, "documentation", null) == null ? [] : [each.value.documentation]
    content {
      content   = documentation.value.content
      mime_type = lookup(documentation.value, "mime_type", null)
    }
  }

  conditions {
    display_name = each.value.conditions.display_name
    name         = lookup(each.value, "name", null)

    dynamic "condition_threshold" {
      for_each = lookup(each.value.conditions, "condition_threshold", null) == null ? [] : [each.value.conditions.condition_threshold]
      content {
        duration           = lookup(condition_threshold.value, "duration", null)
        comparison         = lookup(condition_threshold.value, "comparison", null)
        threshold_value    = lookup(condition_threshold.value, "threshold_value", null)
        denominator_filter = lookup(condition_threshold.value, "denominator_filter", null)
        filter             = lookup(condition_threshold.value, "filter", null)
        dynamic "denominator_aggregations" {
          for_each = lookup(condition_threshold.value, "denominator_aggregations", null) == null ? [] : [condition_threshold.value.denominator_aggregations]
          content {
            per_series_aligner   = lookup(denominator_aggregations.value, "per_series_aligner", null)
            group_by_fields      = lookup(denominator_aggregations.value, "group_by_fields", null)
            alignment_period     = lookup(denominator_aggregations.value, "alignment_period", null)
            cross_series_reducer = lookup(denominator_aggregations.value, "cross_series_reducer", null)
          }
        }
        dynamic "aggregations" {
          for_each = lookup(condition_threshold.value, "aggregations", null) == null ? [] : [condition_threshold.value.aggregations]
          content {
            per_series_aligner   = lookup(aggregations.value, "per_series_aligner", null)
            group_by_fields      = lookup(aggregations.value, "group_by_fields", [])
            alignment_period     = lookup(aggregations.value, "alignment_period", null)
            cross_series_reducer = lookup(aggregations.value, "cross_series_reducer", null)
          }
        }
        dynamic "trigger" {
          for_each = lookup(condition_threshold.value, "trigger", null) == null ? [] : [condition_threshold.value.trigger]
          content {
            percent = lookup(trigger.value, "percent", null)
            count   = lookup(trigger.value, "count", null)
          }
        }
      }
    }

    dynamic "condition_monitoring_query_language" {
      for_each = lookup(each.value.conditions, "condition_monitoring_query_language", null) == null ? [] : [each.value.conditions.condition_monitoring_query_language]
      content {
        query    = lookup(condition_monitoring_query_language.value, "query", null)
        duration = lookup(condition_monitoring_query_language.value, "duration", null)
        dynamic "trigger" {
          for_each = lookup(condition_monitoring_query_language.value, "trigger", null) == null ? [] : [condition_monitoring_query_language.value.trigger]
          content {
            percent = lookup(trigger.value, "percent", null)
            count   = lookup(trigger.value, "count", null)
          }
        }
      }
    }

    dynamic "condition_absent" {
      for_each = lookup(each.value.conditions, "condition_absent", null) == null ? [] : [each.value.conditions.condition_absent]
      content {
        duration = lookup(condition_absent.value, "duration", null)
        filter   = lookup(condition_absent.value, "filter", null)
        dynamic "aggregations" {
          for_each = lookup(condition_absent.value, "aggregations", null) == null ? [] : [condition_absent.value.aggregations]
          content {
            per_series_aligner   = lookup(aggregations.value, "per_series_aligner", null)
            group_by_fields      = lookup(aggregations.value, "group_by_fields", [])
            alignment_period     = lookup(aggregations.value, "alignment_period", null)
            cross_series_reducer = lookup(aggregations.value, "cross_series_reducer", null)
          }
        }
        dynamic "trigger" {
          for_each = lookup(condition_absent.value, "trigger", null) == null ? [] : [condition_absent.value.trigger]
          content {
            percent = lookup(trigger.value, "percent", null)
            count   = lookup(trigger.value, "count", null)
          }
        }
      }
    }
  }
}
