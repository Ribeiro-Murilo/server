
# Bloco de configuração para o provedor do Cloudflare.
# Você precisará configurar sua chave de API do Cloudflare como uma variável de ambiente.
# Ex: export CLOUDFLARE_API_TOKEN="seu_token_aqui"
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

# Configure o provedor do Cloudflare
# Ele usará a variável de ambiente CLOUDFLARE_API_TOKEN para autenticar.
provider "cloudflare" {
  api_token = "b8zB2U3zX-Ohu1Ta_wDYY-jFRIM29_7rzsdtrq0_"
}

# 1. Cria um Cloudflare Tunnel
# Este recurso cria o túnel e gera um "segredo" (token) para ele.
# O nome "meu-servidor-proxmox" é o mesmo que usamos no guia manual.
resource "cloudflare_tunnel" "proxmox_tunnel" {
  # Substitua pelo ID da sua conta Cloudflare. Você pode encontrá-lo na
  # página principal do seu domínio no dashboard do Cloudflare.
  account_id = "1540230af954cd6bbdd23684088b0320"
  name       = "pve"
  secret     = "0000000000000000000000000000000000000000000000000000000000000000"
}

# 2. Configura o túnel (Ingress Rules)
# Isso substitui a necessidade de ter um arquivo config.yml na sua máquina local.
# A configuração é enviada diretamente para a API do Cloudflare.
resource "cloudflare_tunnel_config" "proxmox_config" {
  account_id = cloudflare_tunnel.proxmox_tunnel.account_id
  tunnel_id  = cloudflare_tunnel.proxmox_tunnel.id

  config {
    # Regra 1: Aponta o subdomínio para o serviço local.
    ingress_rule {
      hostname = "proxmox.ribeiroworkes.com"
      service  = "https://192.168.1.61:8006"

      # Equivalente ao 'noTLSVerify: true' para certificados auto-assinados.
      origin_request {
        no_tls_verify = true
      }
    }

    # Regra final obrigatória.
    ingress_rule {
      service = "http_status:404"
    }
  }
}

# 3. Cria o registro DNS (CNAME) para apontar para o túnel.
# Isso substitui o comando 'cloudflared tunnel route dns'.
resource "cloudflare_record" "proxmox_dns" {
  # Substitua pelo ID da sua zona (domínio) no Cloudflare.
  zone_id = "f5369191c50c1a616968aca637fcbbb9"
  name    = "proxmox" # O subdomínio (ex: 'proxmox' para 'proxmox.seudominio.com')
  value   = cloudflare_tunnel.proxmox_tunnel.cname
  type    = "CNAME"
  proxied = true # Habilita o proxy do Cloudflare (a nuvem laranja)
}

# (Opcional) Imprime o token do túnel para facilitar a instalação do serviço.
output "tunnel_token" {
  value     = cloudflare_tunnel.proxmox_tunnel.tunnel_token
  sensitive = true
  description = "Token para instalar o cloudflared como um serviço."
}
