output "display_name" {
  value       = google_monitoring_alert_policy.alert_policy.display_name
  description = "Display Name of the created Alert "
}

output "id" {
  value       = google_monitoring_alert_policy.alert_policy.project_id
  description = "ID of the created Alert policy"
}
