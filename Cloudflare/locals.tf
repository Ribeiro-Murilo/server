# Local values for computed configurations

locals {
  # Common tags for all resources
  common_tags = {
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "terraform"
  }
  
  # Computed hostnames
  proxmox_fqdn   = "${var.proxmox_tunnel_config.hostname}.${var.domain_name}"
  nextcloud_fqdn = "${var.nextcloud_tunnel_config.hostname}.${var.domain_name}"
  
  # Tunnel configurations
  tunnels = {
    proxmox = {
      name        = var.proxmox_tunnel_config.name
      secret      = var.proxmox_tunnel_config.secret
      hostname    = local.proxmox_fqdn
      service_url = var.proxmox_tunnel_config.service_url
      dns_name    = var.proxmox_tunnel_config.hostname
      no_tls_verify = true
    }
    
    nextcloud = {
      name        = var.nextcloud_tunnel_config.name
      secret      = var.nextcloud_tunnel_config.secret
      hostname    = local.nextcloud_fqdn
      service_url = var.nextcloud_tunnel_config.service_url
      dns_name    = var.nextcloud_tunnel_config.hostname
      no_tls_verify = false
    }
  }
}