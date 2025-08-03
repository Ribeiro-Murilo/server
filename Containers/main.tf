# Terraform configuration for Proxmox LXC containers

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9.0"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure     = true
}

# Nextcloud LXC Container
resource "proxmox_lxc" "nextcloud" {
  target_node = var.proxmox_node
  hostname    = var.container_config.hostname
  ostemplate  = var.container_config.ostemplate
  
  cores  = var.container_config.cores
  memory = var.container_config.memory
  
  rootfs {
    storage = var.storage_pool
    size    = var.container_config.disk_size
  }
  
  network {
    name   = var.network_config.interface
    bridge = var.network_config.bridge
    ip     = local.network_ip
    gw     = local.network_gw
  }
  
  ssh_public_keys = var.ssh_public_keys != "" ? var.ssh_public_keys : null
  password        = var.root_password
  
  start = true
  
  tags = local.container_tags
  
  # Evita recriação do container ao alterar certas propriedades
  lifecycle {
    ignore_changes = [
      ostemplate,    # Ignora mudanças no template
      password,      # Ignora mudanças na senha
      rootfs[0].storage,  # Ignora mudanças no storage
    ]
  }
}