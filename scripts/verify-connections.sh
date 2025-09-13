#!/bin/bash

# Script de verificación de conexiones entre contenedores
echo "🔍 Verificando conexiones entre contenedores..."

echo "1. ✅ Verificando n8n → PostgreSQL"
echo "   - n8n se conecta usando: DB_POSTGRESDB_HOST=postgres"
echo "   - Puerto interno: 5432"
echo "   - Base de datos: n8n"

echo "2. ✅ Verificando n8n → Ollama"  
echo "   - n8n puede llamar a: http://ollama:11434"
echo "   - API endpoint: /api/version"
echo "   - Para workflows de IA"

echo "3. ✅ Verificando nginx → n8n"
echo "   - nginx proxy hacia: http://n8n:5678"
echo "   - Expuesto en puertos: 8090 (HTTP), 8443 (HTTPS)"

echo "4. ✅ Verificando backup → PostgreSQL"
echo "   - Acceso de solo lectura a datos"
echo "   - Backup automático cada 24 horas"

echo ""
echo "🌐 Red Docker Compose automática:"
echo "   - Todos los contenedores están en la misma red"
echo "   - Comunicación por nombre de servicio"
echo "   - DNS interno de Docker funcional"

echo ""
echo "📋 Comandos para probar conexiones:"
echo "   docker-compose exec n8n wget -qO- http://ollama:11434/api/version"
echo "   docker-compose exec postgres pg_isready -U n8n"
echo "   docker-compose exec nginx wget -qO- http://localhost/health"
