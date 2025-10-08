#!/bin/bash

# Script para solucionar el problema de pantalla negra en n8n
# Ejecutar en el VPS como: chmod +x fix_n8n.sh && ./fix_n8n.sh

echo "🔧 Solucionando problema de pantalla negra en n8n..."

# 1. Detener los servicios actuales
echo "📦 Deteniendo contenedores actuales..."
docker-compose down

# 2. Limpiar caché de n8n
echo "🧹 Limpiando caché de n8n..."
docker volume rm mi_agente_n8n_data 2>/dev/null || true

# 3. Reiniciar servicios con nueva configuración
echo "🚀 Iniciando servicios con configuración actualizada..."
docker-compose up -d

# 4. Esperar a que los servicios se inicialicen
echo "⏳ Esperando inicialización de servicios..."
sleep 30

# 5. Verificar estado de contenedores
echo "📊 Estado de contenedores:"
docker-compose ps

# 6. Mostrar logs de n8n para diagnóstico
echo "📋 Últimos logs de n8n:"
docker-compose logs n8n --tail 20

# 7. Verificar conectividad
echo "🌐 Verificando conectividad:"
echo "- Evolution API: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ || echo "ERROR")"
echo "- n8n interno: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:5678/healthz || echo "ERROR")"
echo "- Nginx: $(curl -s -o /dev/null -w "%{http_code}" http://localhost:80/health || echo "ERROR")"

echo "✅ Script completado. Intenta acceder a: https://miagentepersonal.me:8443"
echo "ℹ️  Si sigue fallando, ejecuta: docker-compose logs n8n para más detalles"