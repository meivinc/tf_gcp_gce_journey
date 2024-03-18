output "network_common_config" {
  description = "Common configuration data to be used in other steps."
  value = {
    subnet_prefix     = var.subnet_prefix,
    vpc_prefix        = var.vpc_prefix,
    serverless_prefix = var.serverless_prefix,
    firewall_prefix   = var.firewall_prefix
    cloud_nat_prefix = var.cloud_nat_prefix
    cloud_router_prefix = var.cloud_router_prefix
  }
}


output "vpc_subnet" {
  description = "Subnet URI"
  value = {
    for subnet in module.demo_subnet.subnets :
    subnet.name => subnet.id
  }
}

output "vpc_name" {
  description = "VPC name"
  value       = module.vpc_network["network"].name
}



