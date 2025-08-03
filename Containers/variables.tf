# Variables for Proxmox LXC containers

# Proxmox API Configuration
variable "proxmox_api_url" {
  description = "URL da API do Proxmox"
  type        = string
  default     = "https://192.168.1.61:8006/api2/json"
  
  validation {
    condition     = can(regex("^https://", var.proxmox_api_url))
    error_message = "Proxmox API URL must start with https://."
  }
}

variable "proxmox_token_id" {
  description = "ID do token do Proxmox"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.proxmox_token_id) > 5
    error_message = "Proxmox token ID must be valid."
  }
}

variable "proxmox_token_secret" {
  description = "Secret do token do Proxmox"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.proxmox_token_secret) > 10
    error_message = "Proxmox token secret must be valid."
  }
}

variable "proxmox_node" {
  description = "Nome do nó do Proxmox"
  type        = string
  default     = "pve"
}

variable "storage_pool" {
  description = "Pool de armazenamento"
  type        = string
  default     = "DATA"
}

# Container Configuration
variable "container_config" {
  description = "Configuração do container Nextcloud"
  type = object({
    hostname    = string
    ostemplate  = string
    cores       = number
    memory      = number
    disk_size   = string
    ip_address  = optional(string, "dhcp")
    gateway     = optional(string, null)
  })
  default = {
    hostname    = "nextcloud"
    ostemplate  = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
    cores       = 4
    memory      = 8192
    disk_size   = "200G"
    ip_address  = "dhcp"
    gateway     = null
  }
}

variable "network_config" {
  description = "Configuração de rede"
  type = object({
    interface = string
    bridge    = string
  })
  default = {
    interface = "eth0"
    bridge    = "vmbr0"
  }
}

# Authentication
variable "ssh_public_keys" {
  description = "Chaves SSH públicas para acesso ao container"
  type        = string
  default     = ""
}

variable "root_password" {
  description = "Senha do usuário root do container"
  type        = string
  sensitive   = true
  default     = "nextcloud123"
  
  validation {
    condition     = length(var.root_password) >= 8
    error_message = "Root password must be at least 8 characters long."
  }
}

# Tags and metadata
variable "environment" {
  description = "Environment tag for resources"
  type        = string
  default     = "production"
}

variable "project" {
  description = "Project name for tagging"
  type        = string
  default     = "homelab"
}

variable "additional_tags" {
  description = "Additional tags for the container"
  type        = list(string)
  default     = ["nextcloud", "lxc"]
}