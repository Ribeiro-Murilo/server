# Configuração para o Terraform do Proxmox
# Configuração atual refatorada

# Configuração da API do Proxmox
proxmox_api_url = "https://192.168.1.61:8006/api2/json"
proxmox_token_id = "root@pam!container"
proxmox_token_secret = "4c6bf361-f598-4ad8-a906-726275421318"
proxmox_node = "pve"
storage_pool = "DATA"

# Configuração do container (valores atuais após mudanças no Proxmox)
container_config = {
  hostname    = "nextcloud"
  ostemplate  = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
  cores       = 2
  memory      = 2048
  disk_size   = "200G"
  ip_address  = "dhcp"
  gateway     = null
}

# Configuração de rede
network_config = {
  interface = "eth0"
  bridge    = "vmbr0"
}

# Autenticação
ssh_public_keys = ""
root_password = "nextcloud123"

# Tags e metadados (correspondendo ao estado atual)
environment = "lxc"
project = "nextcloud"
additional_tags = [] 