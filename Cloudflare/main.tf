# Terraform configuration for Cloudflare tunnels and DNS

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
  }
}

# Configure Cloudflare provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Create Cloudflare Tunnels
resource "cloudflare_tunnel" "tunnels" {
  for_each = local.tunnels
  
  account_id = var.cloudflare_account_id
  name       = each.value.name
  secret     = each.value.secret
  
  lifecycle {
    ignore_changes = [secret]
  }
}

# Configure tunnel routing
resource "cloudflare_tunnel_config" "tunnel_configs" {
  for_each = local.tunnels
  
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_tunnel.tunnels[each.key].id

  config {
    # Primary ingress rule
    ingress_rule {
      hostname = each.value.hostname
      service  = each.value.service_url

      # Configure origin request settings when needed
      dynamic "origin_request" {
        for_each = each.value.no_tls_verify ? [1] : []
        content {
          no_tls_verify = true
        }
      }
    }

    # Catch-all rule (required)
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# Create DNS records for tunnels
resource "cloudflare_record" "tunnel_dns" {
  for_each = local.tunnels
  
  zone_id         = var.cloudflare_zone_id
  name            = each.value.dns_name
  content         = cloudflare_tunnel.tunnels[each.key].cname
  type            = "CNAME"
  proxied         = true
  allow_overwrite = true
  comment         = "Managed by Terraform - ${each.value.name} tunnel"
}