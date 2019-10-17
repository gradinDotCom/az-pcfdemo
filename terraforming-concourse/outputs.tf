
output "static_ips" {
  value       = "${var.static_ips}"
}

output "hostname" {
  value       = "${var.hostname}"
}

output "services_subnet_name" {
  value = "${data.azurerm_subnet.pcf-svcs.name}"
}

output "ssl_cert" {
  sensitive = true
  value     = "${var.ssl_cert}"
}

output "ssl_private_key" {
  sensitive = true
  value     = "${var.ssl_private_key}"
}

# output "concourse_lb_name" {
#   value = "${module.concourse.concourse_lb_name}"
# }