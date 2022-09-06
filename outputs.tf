output "all_alerts" {
  value = ["${module.google_monitoring_alert_policy.*.id}"]
 }

