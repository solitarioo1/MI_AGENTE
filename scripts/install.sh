#!/bin/bash

# Script de instalación automática para VPS Ubuntu/Debian
# Basado en la experiencia de conexionVPS pero mejorado para multi-contenedores
# Ejecutar con: bash install.sh

set -e

echo "🚀 Instalando Agente Asistente Personal..."
echo "📝 Basado en tu experiencia previa con Docker en VPS"

# Verificar si es root
if [[ $EUID -eq 0 ]]; then
   echo "❌ No ejecutes este script como root. Usa un usuario normal con sudo."
   exit 1
fi

# Actualizar sistema
echo "📦 Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar Docker (igual que en tu proyecto conexionVPS pero mejorado)
echo "🐳 Instalando Docker..."
if ! command -v docker &> /dev/null; then
    echo "📦 Descargando e instalando Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    rm get-docker.sh
    
    # Iniciar y habilitar Docker (como en tu VPS)
    sudo systemctl start docker
    sudo systemctl enable docker
    echo "✅ Docker instalado y configurado"
else
    echo "✅ Docker ya está instalado (como en tu proyecto anterior)"
fi

# Instalar Docker Compose (método mejorado vs tu instalación básica)
echo "🔧 Instalando Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "✅ Docker Compose instalado (versión mejorada vs apt install)"
else
    echo "✅ Docker Compose ya está instalado"
fi

# Crear directorios necesarios
echo "📁 Creando directorios..."
mkdir -p backups ssl

# Configurar permisos
echo "🔐 Configurando permisos..."
chmod 755 backups
chmod 700 ssl

# Configurar .env
echo "⚙️ Configurando variables de entorno..."
if [ ! -f .env ]; then
    echo "❌ Archivo .env no encontrado. Créalo primero."
    exit 1
fi

# Configurar firewall (como tu experiencia con puertos personalizados)
echo "🛡️ Configurando firewall..."
if command -v ufw &> /dev/null; then
    sudo ufw allow 22/tcp     # SSH
    sudo ufw allow 8090/tcp   # HTTP personalizado (como tu 8080)
    sudo ufw allow 8443/tcp   # HTTPS personalizado
    sudo ufw --force enable
    echo "✅ Firewall configurado con puertos personalizados"
    echo "📝 Recuerda: Configura también Azure NSG como en tu proyecto anterior"
fi

# Verificar recursos del sistema
echo "💾 Verificando recursos del sistema..."
TOTAL_MEM=$(free -m | awk 'NR==2{print $2}')
if [ $TOTAL_MEM -lt 3500 ]; then
    echo "⚠️  ADVERTENCIA: Tu VPS tiene menos de 4GB RAM ($TOTAL_MEM MB)"
    echo "   El agente podría funcionar lento. Recomendamos mínimo 4GB."
fi

echo "✅ Instalación completada!"
echo ""
echo "🎯 PRÓXIMOS PASOS (Basados en tu experiencia con conexionVPS):"
echo "1. Generar SSL: ./scripts/generate-ssl.sh"
echo "2. Editar .env: nano .env (como configuraste tu proyecto anterior)"
echo "3. Iniciar servicios: ./scripts/manage.sh start"
echo "4. Instalar IA: ./scripts/manage.sh install-mistral"
echo "5. Configurar Azure NSG (como hiciste antes):"
echo "   - Puerto 8090 (HTTP)"
echo "   - Puerto 8443 (HTTPS)"
echo ""
echo "🌐 ACCESO FINAL:"
echo "   HTTP:  http://172.206.16.218:8090"
echo "   HTTPS: https://172.206.16.218:8443"
echo ""
echo "� DIFERENCIA vs tu proyecto anterior:"
echo "   - Más servicios (5 contenedores vs 1)"
echo "   - Configuración más compleja pero automatizada"
echo "   - Mismo flujo: git clone → configurar → docker up"
echo ""
echo "📚 Lee VPS-GUIDE.md para comparación detallada con conexionVPS"
