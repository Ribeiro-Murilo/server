# Local values for computed configurations

locals {
  # Common tags for all resources
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
  
  # Container configuration
  container_name = var.container_config.hostname
  
  # Network configuration - determine if using static IP or DHCP
  use_static_ip = var.container_config.ip_address != "dhcp"
  
  # Combined tags for the container (matching current state)
  container_tags = "lxc;nextcloud;managed-by-terraform"
  
  # Network settings based on configuration
  network_ip = local.use_static_ip ? var.container_config.ip_address : "dhcp"
  network_gw = local.use_static_ip ? var.container_config.gateway : null
}