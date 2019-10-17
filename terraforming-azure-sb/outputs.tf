output "database_server" {
    value = "${var.database_server}"
}
output "database_encryption_key" {
    value = "${var.database_encryption_key}"
    sensitive = true
}
output "database_name" {
    value = "${var.database_name}"
}
output "database_password" {
    value = "${var.database_password}"
    sensitive = true
}
output "database_user" {
    value = "${var.database_user}"
}
output "services_subnet_name" {
    value = "${var.pcf_svcs_name}"
}
output "client_id" {
    sensitive = true
    value = "${var.client_id}"
}
output "client_secret" {
    sensitive = true
    value = "${var.client_secret}"
}
output "subscription_id" {
    sensitive = true
    value = "${var.subscription_id}"
}
output "tenant_id" {
    sensitive = true
    value = "${var.subscription_id}"
}