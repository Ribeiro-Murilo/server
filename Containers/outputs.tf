# Output values for Proxmox container configuration

output "container_info" {
  description = "Complete information about the created container"
  value = {
    vmid     = proxmox_lxc.nextcloud.vmid
    hostname = proxmox_lxc.nextcloud.hostname
    node     = proxmox_lxc.nextcloud.target_node
    status   = proxmox_lxc.nextcloud.start ? "running" : "stopped"
  }
}

output "network_info" {
  description = "Network configuration of the container"
  value = {
    ip_address = proxmox_lxc.nextcloud.network[0].ip
    gateway    = proxmox_lxc.nextcloud.network[0].gw
    bridge     = proxmox_lxc.nextcloud.network[0].bridge
    interface  = proxmox_lxc.nextcloud.network[0].name
  }
}

output "resource_allocation" {
  description = "Resource allocation for the container"
  value = {
    cores       = proxmox_lxc.nextcloud.cores
    memory_mb   = proxmox_lxc.nextcloud.memory
    disk_size   = proxmox_lxc.nextcloud.rootfs[0].size
    storage     = proxmox_lxc.nextcloud.rootfs[0].storage
  }
}

# Backward compatibility outputs
output "nextcloud_ip" {
  description = "IP do container Nextcloud"
  value       = proxmox_lxc.nextcloud.network[0].ip
}

output "nextcloud_vmid" {
  description = "ID do container Nextcloud"
  value       = proxmox_lxc.nextcloud.vmid
}

output "nextcloud_hostname" {
  description = "Hostname do container Nextcloud"
  value       = proxmox_lxc.nextcloud.hostname
}

output "container_url" {
  description = "URL de acesso ao container (assuming web interface)"
  value       = "http://${proxmox_lxc.nextcloud.network[0].ip}"
}

output "management_info" {
  description = "Informações para gerenciamento"
  value = {
    proxmox_web = "https://192.168.1.61:8006"
    ssh_access  = var.ssh_public_keys != "" ? "ssh root@${proxmox_lxc.nextcloud.network[0].ip}" : "SSH keys not configured"
    tags        = proxmox_lxc.nextcloud.tags
  }
}