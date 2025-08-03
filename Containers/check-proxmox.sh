#!/bin/bash

echo "🔍 Verificação de Configurações do Proxmox"
echo "=========================================="

# Verificar se o curl está disponível
if ! command -v curl &> /dev/null; then
    echo "❌ curl não encontrado. Instale o curl primeiro."
    exit 1
fi

# Configurações que precisam ser verificadas
echo ""
echo "📋 Informações que você precisa verificar manualmente:"
echo ""
echo "1. 🌐 IP do Proxmox: 192.168.1.61 (já configurado)"
echo "2. 🏷️  Nome do nó: pve (verificar no painel web)"
echo "3. 💾 Storage: DATA (verificar se existe)"
echo "4. 📦 Template: debian-12-standard_12.7-1_amd64.tar.zst"
echo "5. 🌉 Bridge: vmbr0 (verificar em System → Network)"
echo "6. 🔑 Token API: precisa ser criado"
echo ""

echo "🔧 Como verificar cada item:"
echo ""
echo "📦 Template Debian:"
echo "   - Vá em: Datacenter → local → CT Templates"
echo "   - Ou: Datacenter → DATA → CT Templates"
echo "   - Procure por: debian-12-standard_12.7-1_amd64.tar.zst"
echo ""
echo "🌉 Bridge de Rede:"
echo "   - Vá em: Datacenter → pve → System → Network"
echo "   - Verifique se vmbr0 existe"
echo ""
echo "🔑 Token de API:"
echo "   - Vá em: Datacenter → Permissions → API Tokens"
echo "   - Clique em Add"
echo "   - User: root@pam"
echo "   - Token ID: terraform"
echo "   - Privilege Separation: ✅ habilitado"
echo ""

echo "✅ Após verificar, atualize o arquivo terraform.tfvars com os valores corretos" 