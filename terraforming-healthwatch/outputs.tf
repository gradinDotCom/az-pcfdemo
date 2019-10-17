output "services_subnet_name" {
  value = "${var.pcf_svcs_name}"
}

output "healthwatch_uaa_user" {
  value = "${var.healthwatch_uaa_user}"
}

output "healthwatch_uaa_password" {
  sensitive = true
  value = "${var.healthwatch_uaa_password}"
}

output "opsman_url" {
  value = "${var.opsman_url}"
}

output "foundation_name" {
  value = "${var.foundation_name}"
}