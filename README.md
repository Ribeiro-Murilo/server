# Infraestrutura como Código (IaC)

Este diretório contém a configuração do Terraform para gerenciar a infraestrutura do homelab, incluindo containers Proxmox e configurações do Cloudflare.

## Estrutura do Projeto

```
Infra/
├── README.md                    # Este arquivo
├── Cloudflare/                  # Configurações do Cloudflare (Túneis e DNS)
│   ├── main.tf                  # Recursos principais
│   ├── variables.tf             # Definição de variáveis
│   ├── locals.tf                # Valores computados
│   ├── outputs.tf               # Saídas da configuração
│   └── terraform.tfvars.example # Exemplo de variáveis
└── Containers/                  # Configurações de containers Proxmox
    ├── main.tf                  # Recursos principais
    ├── variables.tf             # Definição de variáveis
    ├── locals.tf                # Valores computados
    ├── outputs.tf               # Saídas da configuração
    └── terraform.tfvars.example # Exemplo de variáveis
```

## Recursos Gerenciados

### Cloudflare
- **Túneis**: Conexões seguras para Proxmox e Nextcloud
- **DNS**: Registros CNAME para acesso público
- **Configuração**: Roteamento de ingress para serviços internos

### Proxmox
- **Containers LXC**: Container Debian para Nextcloud
- **Rede**: Configuração de IP (DHCP ou estático)
- **Recursos**: CPU, memória e armazenamento

## Como Usar

### 1. Configuração Inicial

Para cada módulo (Cloudflare/Containers), copie o arquivo de exemplo:

```bash
# Para Cloudflare
cd Infra/Cloudflare
cp terraform.tfvars.example terraform.tfvars

# Para Containers
cd Infra/Containers
cp terraform.tfvars.example terraform.tfvars
```

### 2. Configurar Variáveis

Edite os arquivos `terraform.tfvars` com seus valores específicos:

#### Cloudflare
- `cloudflare_api_token`: Token da API do Cloudflare
- `cloudflare_account_id`: ID da conta Cloudflare
- `cloudflare_zone_id`: ID da zona do domínio

#### Containers
- `proxmox_token_id`: ID do token do Proxmox
- `proxmox_token_secret`: Secret do token
- `ssh_public_keys`: Suas chaves SSH públicas

### 3. Executar Terraform

Para cada módulo:

```bash
# Inicializar Terraform
terraform init

# Verificar o plano
terraform plan

# Aplicar as configurações
terraform apply
```

## Características da Refatoração

### Melhorias Implementadas

1. **Modularização**: Separação clara entre Cloudflare e Containers
2. **Variáveis Tipadas**: Validação e tipos definidos para todas as variáveis
3. **Configuração por Objetos**: Agrupamento lógico de configurações relacionadas
4. **Locals**: Valores computados centralizados
5. **Outputs Estruturados**: Saídas organizadas e informativas
6. **Tags Consistentes**: Sistema de tags padronizado
7. **Validações**: Verificações de entrada para valores críticos
8. **Segurança**: Variáveis sensíveis marcadas adequadamente

### Compatibilidade

- **IPs e Chaves**: Todos os endereços IP e IDs de chave foram preservados
- **Funcionalidade**: Comportamento idêntico ao setup anterior
- **Outputs**: Mantida compatibilidade com saídas existentes

### Configurações Flexíveis

#### Rede do Container
Suporte para dois modos:
- **DHCP**: IP automático (padrão)
- **Estático**: IP fixo configurável

#### Túneis Cloudflare
Configuração através de objetos para facilitar manutenção:
- URLs de serviço configuráveis
- Secrets gerenciados como variáveis
- Hostnames flexíveis

## Variáveis Importantes

### Preservadas (não alterar)
- `proxmox_api_url`: `https://192.168.1.61:8006/api2/json`
- `cloudflare_account_id`: `1540230af954cd6bbdd23684088b0320`
- `cloudflare_zone_id`: `f5369191c50c1a616968aca637fcbbb9`
- IPs dos serviços: `192.168.1.61`, `192.168.1.66`, `192.168.1.100`
- Secrets dos túneis

### Configuráveis
- Tags de ambiente e projeto
- Recursos do container (CPU, memória, disco)
- Modo de rede (DHCP vs estático)
- Chaves SSH e senhas

## Troubleshooting

### Erros Comuns

1. **Token inválido**: Verifique se os tokens do Proxmox e Cloudflare estão corretos
2. **Recursos insuficientes**: Ajuste CPU/memória se necessário
3. **Conflitos de IP**: Para modo estático, garanta que o IP esteja disponível
4. **DNS propagation**: Aguarde propagação DNS após alterações

### Logs e Debugging

```bash
# Logs detalhados
terraform apply -auto-approve -refresh=true

# Estado atual
terraform show

# Outputs
terraform output
```

## Próximos Passos

1. Considerar uso de Terraform Cloud/Enterprise para estado remoto
2. Implementar CI/CD para mudanças automáticas
3. Adicionar monitoramento e alertas
4. Expandir para outros serviços do homelab