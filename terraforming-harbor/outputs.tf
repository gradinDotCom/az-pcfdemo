
output "static_ips" {
  value       = "${var.static_ips}"
}

output "hostname" {
  value       = "${var.hostname}"
}

output "services_subnet_name" {
  value = "${data.azurerm_subnet.pcf-svcs.name}"
}

output "admin_password" {
  sensitive = true
  value = "${var.admin_password}"
}

output "admin_password_for_smoketest" {
  sensitive = true
  value = "${var.admin_password_for_smoketest}"
}

output "ssl_cert" {
  sensitive = true
  value     = "${var.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${var.ssl_private_key}"
}

output "harbor_lb_name" {
  value = "${module.harbor.harbor_lb_name}"
}