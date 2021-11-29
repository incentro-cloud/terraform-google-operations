# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# SLOs
# Submodule for creating the SLOs.
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
# SLOs
# ---------------------------------------------------------------------------------------------------------------------

resource "google_monitoring_slo" "slos" {
  for_each            = { for slo in var.slos : slo.slo_id => slo }
  project             = var.project_id
  service             = each.value.service
  slo_id              = each.value.slo_id
  display_name        = each.value.display_name
  goal                = each.value.goal
  rolling_period_days = each.value.rolling_period_days
  calendar_period     = each.value.calendar_period

  dynamic "basic_sli" {
    for_each = lookup(each.value, "basic_sli") == null ? [] : [each.value.basic_sli]
    content {
      method   = lookup(basic_sli.value, "method", null)
      location = lookup(basic_sli.value, "location", null)
      version  = lookup(basic_sli.value, "version", null)
      dynamic "latency" {
        for_each = lookup(basic_sli.value, "latency", null) == null ? [] : [basic_sli.value.latency]
        content {
          threshold = latency.value.threshold
        }
      }
      dynamic "availability" {
        for_each = lookup(basic_sli.value, "availability", null) == null ? [] : [basic_sli.value.availability]
        content {
          enabled = lookup(availability.value, "enabled", true)
        }
      }
    }
  }

  dynamic "request_based_sli" {
    for_each = lookup(each.value, "request_based_sli") == null ? [] : [each.value.request_based_sli]
    content {
      dynamic "good_total_ratio" {
        for_each = lookup(request_based_sli.value, "good_total_ratio", null) == null ? [] : [request_based_sli.value.good_total_ratio]
        content {
          good_service_filter  = lookup(good_total_ratio.value, "good_service_filter", null)
          bad_service_filter   = lookup(good_total_ratio.value, "bad_service_filter", null)
          total_service_filter = lookup(good_total_ratio.value, "total_service_filter", null)
        }
      }
      dynamic "distribution_cut" {
        for_each = lookup(request_based_sli.value, "distribution_cut", null) == null ? [] : [request_based_sli.value.distribution_cut]
        content {
          distribution_filter = distribution_cut.value.distribution_filter
          range {
            min = lookup(distribution_cut.value, "min", null)
            max = lookup(distribution_cut.value, "max", null)
          }
        }
      }
    }
  }

  dynamic "windows_based_sli" {
    for_each = lookup(each.value, "windows_based_sli") == null ? [] : [each.value.windows_based_sli]
    content {
      window_period          = lookup(windows_based_sli.value, "window_period", null)
      good_bad_metric_filter = lookup(windows_based_sli.value, "good_bad_metric_filter", null)
      dynamic "good_total_ratio_threshold" {
        for_each = lookup(windows_based_sli.value, "good_total_ratio_threshold", null) == null ? [] : [windows_based_sli.value.good_total_ratio_threshold]
        content {
          threshold = lookup(good_total_ratio_threshold.value, "threshold", null)
          dynamic "performance" {
            for_each = lookup(good_total_ratio_threshold.value, "performance", null) == null ? [] : [good_total_ratio_threshold.value.performance]
            content {
              dynamic "good_total_ratio" {
                for_each = lookup(performance.value, "good_total_ratio", null) == null ? [] : [performance.value.good_total_ratio]
                content {
                  good_service_filter  = lookup(good_total_ratio.value, "good_service_filter", null)
                  bad_service_filter   = lookup(good_total_ratio.value, "bad_service_filter", null)
                  total_service_filter = lookup(good_total_ratio.value, "total_service_filter", null)
                }
              }
              dynamic "distribution_cut" {
                for_each = lookup(performance.value, "distribution_cut", null) == null ? [] : [performance.value.distribution_cut]
                content {
                  distribution_filter = distribution_cut.value.distribution_filter
                  range {
                    min = lookup(distribution_cut.value, "min", null)
                    max = lookup(distribution_cut.value, "max", null)
                  }
                }
              }
            }
          }
          dynamic "basic_sli_performance" {
            for_each = lookup(good_total_ratio_threshold.value, "basic_sli_performance", null) == null ? [] : [good_total_ratio_threshold.value.basic_sli_performance]
            content {
              method   = lookup(basic_sli_performance.value, "method", null)
              location = lookup(basic_sli_performance.value, "location", null)
              version  = lookup(basic_sli_performance.value, "version", null)
              dynamic "latency" {
                for_each = lookup(basic_sli_performance.value, "latency", null) == null ? [] : [basic_sli_performance.value.latency]
                content {
                  threshold = latency.value.threshold
                }
              }
              dynamic "availability" {
                for_each = lookup(basic_sli_performance.value, "availability", null) == null ? [] : [basic_sli_performance.value.availability]
                content {
                  enabled = lookup(availability.value, "enabled", true)
                }
              }
            }
          }
        }
      }
      dynamic "metric_mean_in_range" {
        for_each = lookup(windows_based_sli.value, "metric_mean_in_range", null) == null ? [] : [windows_based_sli.value.metric_mean_in_range]
        content {
          time_series = metric_mean_in_range.value.time_series
          range {
            min = lookup(metric_mean_in_range.value, "min", null)
            max = lookup(metric_mean_in_range.value, "max", null)
          }
        }
      }
      dynamic "metric_sum_in_range" {
        for_each = lookup(windows_based_sli.value, "metric_sum_in_range", null) == null ? [] : [windows_based_sli.value.metric_sum_in_range]
        content {
          time_series = metric_sum_in_range.value.time_series
          range {
            min = lookup(metric_sum_in_range.value, "min", null)
            max = lookup(metric_sum_in_range.value, "max", null)
          }
        }
      }
    }
  }
}
