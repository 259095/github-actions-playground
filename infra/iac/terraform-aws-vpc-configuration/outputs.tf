output "azs_names" {
    value = data.aws_availability_zones.available.names
}

output "private_subnets" {
  value = concat(data.null_data_source.private_subnets.*.outputs.outputs)
}

output "public_subnets" {
  value = concat(data.null_data_source.public_subnets.*.outputs.outputs)
}