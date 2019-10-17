
output "services_subnet_name" {
  value = "${var.pcf_svcs_name}"
}
output "api_endpoint" {
  value = "${var.api_endpoint}"
}
output "splunk_host" {
  value = "${var.splunk_host}"
}
output "splunk_token" {
  sensitive = true
  value = "${var.splunk_token}"
}
output "splunk_api_user" {
  value = "${var.splunk_api_user}"
}
output "splunk_api_password" {
  sensitive = true
  value = "${var.splunk_api_password}"
}
