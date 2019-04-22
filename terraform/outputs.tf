#output "apps_external_ip" {
#  value = "${google_compute_instance.app.*.network_interface.0.access_config.0.assigned_nat_ip}"
#}
#output "lb_external_ip" {
#  value = "${google_compute_forwarding_rule.default.ip_address}"
#}
#output "db_external_ip" {
#  value = "${google_compute_instance.db.*.network_interface.0.access_config.0.assigned_nat_ip}"
#}

output "apps_external_ip" {
  value = "${module.app.apps_external_ip}"
}

output "apps_local_ip" {
  value = "${module.app.apps_local_ip}"
}

output "db_external_ip" {
  value = "${module.db.db_external_ip}"
}

output "db_local_ip" {
  value = "${module.db.db_local_ip}"
}

