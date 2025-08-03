# Variables for Cloudflare configuration

variable "cloudflare_api_token" {
  description = "Cloudflare API token for authentication"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.cloudflare_api_token) > 20
    error_message = "Cloudflare API token must be valid."
  }
}

variable "cloudflare_account_id" {
  description = "Cloudflare account ID"
  type        = string
  
  validation {
    condition     = length(var.cloudflare_account_id) == 32
    error_message = "Cloudflare account ID must be 32 characters long."
  }
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID for domain"
  type        = string
  
  validation {
    condition     = length(var.cloudflare_zone_id) == 32
    error_message = "Cloudflare zone ID must be 32 characters long."
  }
}

variable "domain_name" {
  description = "Base domain name"
  type        = string
  default     = "ribeiroworkes.com"
}

# Proxmox Configuration
variable "proxmox_tunnel_config" {
  description = "Configuration for Proxmox tunnel"
  type = object({
    name        = string
    hostname    = string
    service_url = string
    secret      = string
  })
  default = {
    name        = "pve"
    hostname    = "proxmox"
    service_url = "https://192.168.1.61:8006"
    secret      = "0000000000000000000000000000000000000000000000000000000000000000"
  }
}

# Nextcloud Configuration
variable "nextcloud_tunnel_config" {
  description = "Configuration for Nextcloud tunnel"
  type = object({
    name        = string
    hostname    = string
    service_url = string
    secret      = string
  })
  default = {
    name        = "nextcloud"
    hostname    = "cloud"
    service_url = "http://192.168.1.66:80"
    secret      = "1111111111111111111111111111111111111111111111111111111111111111"
  }
}

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