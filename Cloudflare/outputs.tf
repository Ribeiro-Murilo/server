# Output values for Cloudflare configuration

output "tunnel_tokens" {
  description = "Tokens for installing cloudflared as services"
  value = {
    for name, tunnel in cloudflare_tunnel.tunnels : name => tunnel.tunnel_token
  }
  sensitive = true
}

output "tunnel_ids" {
  description = "Cloudflare tunnel IDs"
  value = {
    for name, tunnel in cloudflare_tunnel.tunnels : name => tunnel.id
  }
}

output "tunnel_cnames" {
  description = "Cloudflare tunnel CNAME values"
  value = {
    for name, tunnel in cloudflare_tunnel.tunnels : name => tunnel.cname
  }
}

output "dns_records" {
  description = "Created DNS records"
  value = {
    for name, record in cloudflare_record.tunnel_dns : name => {
      name     = record.name
      hostname = record.hostname
      value    = record.content
      proxied  = record.proxied
    }
  }
}

# Individual outputs for backwards compatibility
output "proxmox_tunnel_token" {
  description = "Token para instalar o cloudflared do Proxmox como um serviço"
  value       = cloudflare_tunnel.tunnels["proxmox"].tunnel_token
  sensitive   = true
}

output "nextcloud_tunnel_token" {
  description = "Token para instalar o cloudflared do Nextcloud como um serviço"
  value       = cloudflare_tunnel.tunnels["nextcloud"].tunnel_token
  sensitive   = true
}

output "proxmox_url" {
  description = "URL de acesso ao Proxmox"
  value       = "https://${local.proxmox_fqdn}"
}

output "nextcloud_url" {
  description = "URL de acesso ao Nextcloud"
  value       = "https://${local.nextcloud_fqdn}"
}