
output "services_subnet_name" {
  value = "${var.pcf_svcs_name}"
}
output "redis_backup_account" {
  value = "${var.redis_backup_account}"
}
output "redis_backup_container" {
  value = "${var.redis_backup_container}"
}
output "redis_backup_path" {
  value = "${var.redis_backup_path}"
}
output "storage_access_key" {
  sensitive = true
  value = "${var.storage_access_key}"
}

output "redis_subnet_name" {
  value = "${var.redis_subnet_name}"
}