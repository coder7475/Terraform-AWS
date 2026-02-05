output "formatted_project_name" {
  value = local.formatted_project_name
}

output "port_list" {
  value = local.port_list
}

output "sg_rules" {
  value = local.sg_rules
}

output "instance_size" {
  value = local.instance_size
}

output "credentials" {
  value = var.credentials
  sensitive = true
}

output "all_locations" {
  value = local.all_locations
}

output "unique_locations" {
  value = local.unique_locations
}

output "positive_cost" {
  value = local.positive_cost
}

output "total_cost" {
  value = local.total_cost
}
output "avg_cost" {
  value = local.avg_cost
}

output "max_cost" {
  value = local.max_cost
}

output "min_cost" {
  value = local.min_cost
}

output "timestamp" {
  value = local.current_timestamp
}

output "formatted_timestamp_1" {
  value = local.format_1
}

output "formatted_timestamp_2" {
  value = local.format_2
}

output "formatted_timestamp_3" {
  value = local.format_3
}

output "formatted_timestamp_4" {
  value = local.format_4
}

output "decoded_data" {
  value = local.config_data
}
