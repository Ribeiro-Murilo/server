# Container Proxmox - Terraform Refatorado

## ✅ Status: FUNCIONANDO

Esta configuração Terraform foi **completamente refatorada** e está funcionando corretamente após resolução dos problemas anteriores.

## 🏗️ Estrutura Refatorada

```
Containers/
├── main.tf                     # Configuração principal do container
├── variables.tf                # Variáveis tipadas com validações
├── locals.tf                   # Valores computados
├── outputs.tf                  # Saídas estruturadas
├── terraform.tfvars            # Configuração atual
├── terraform.tfvars.example    # Modelo para novos deployments
└── README.md                   # Este arquivo
```

## 📊 Container Atual

| Propriedade | Valor |
|-------------|-------|
| **VMID** | 100 |
| **Hostname** | nextcloud |
| **CPU** | 2 cores |
| **RAM** | 2048 MB (2GB) |
| **Disco** | 200G |
| **Storage** | DATA |
| **Rede** | DHCP no bridge vmbr0 |
| **Status** | ✅ Funcionando |

## 🚀 Como Usar

### 1. Verificar Estado Atual
```bash
cd Infra/Containers
terraform plan
# Deve mostrar: "No changes. Your infrastructure matches the configuration."
```

### 2. Visualizar Informações
```bash
terraform output
# Mostra todas as informações do container
```

### 3. Para Novos Deployments
```bash
cp terraform.tfvars.example terraform.tfvars
# Editar terraform.tfvars com suas configurações
terraform init
terraform plan
terraform apply
```

## 🛡️ Características de Segurança

### Lifecycle Protection
A configuração inclui proteções para evitar destruição acidental:

```hcl
lifecycle {
  ignore_changes = [
    ostemplate,         # Previne recriação por mudança de template
    password,           # Previne recriação por mudança de senha
    rootfs[0].storage,  # Previne recriação por mudança de storage
  ]
}
```

### Validações
- **API URL**: Deve começar com `https://`
- **Tokens**: Verificação de comprimento mínimo
- **Senha**: Mínimo 8 caracteres

## 📋 Outputs Disponíveis

### Informações do Container
```bash
terraform output container_info
# { hostname, node, status, vmid }
```

### Configuração de Rede
```bash
terraform output network_info
# { ip_address, gateway, bridge, interface }
```

### Alocação de Recursos
```bash
terraform output resource_allocation
# { cores, memory_mb, disk_size, storage }
```

### Informações de Gerenciamento
```bash
terraform output management_info
# { proxmox_web, ssh_access, tags }
```

## 🔧 Modificações Seguras

### Alterar Recursos (CPU/RAM)
1. **Via Proxmox Web**: Interface gráfica (recomendado)
2. **Via CLI Proxmox**:
   ```bash
   pct set 100 -cores 4 -memory 4096
   ```
3. **Via Terraform**:
   ```bash
   # Editar terraform.tfvars
   # Alterar cores/memory em container_config
   terraform plan
   terraform apply
   ```

### Configuração de Rede
- **DHCP** (atual): `ip_address = "dhcp"`
- **IP Fixo**: `ip_address = "192.168.1.100/24"` + `gateway = "192.168.1.1"`

## 🔍 Troubleshooting

### Problema: Terraform quer recriar container
**Solução**: Verifique se `ostemplate`, `password` e `storage` estão corretos

### Problema: Erro 400 Parameter verification failed
**Solução**: Use `lifecycle { ignore_changes = [...] }` para parâmetros problemáticos

### Problema: Estado inconsistente
**Solução**: 
```bash
terraform refresh
terraform plan
```

## 📚 Arquivos Históricos

- `PROBLEMAS_CONHECIDOS.md`: Documentação dos problemas anteriores (agora resolvidos)
- `check-proxmox.sh`: Script de verificação da conectividade

## 🎯 Próximos Passos

1. ✅ **Configuração estável**: Completada
2. ✅ **Outputs informativos**: Implementados
3. ✅ **Proteções de segurança**: Ativadas
4. 🔄 **Expansão futura**: Adicionar mais containers conforme necessário

---

**Última atualização**: $(date)  
**Status**: ✅ Funcionando perfeitamente  
**Terraform Version**: >= 1.0  
**Provider**: telmate/proxmox ~> 2.9.0