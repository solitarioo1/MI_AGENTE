#!/bin/bash

# Script de gestión del agente
# Uso: ./manage.sh [comando]

set -e

COMPOSE_FILE="docker-compose.yml"

case "$1" in
    start)
        echo "🚀 Iniciando Agente Asistente Personal..."
        docker-compose up -d
        echo "✅ Servicios iniciados"
        echo "📍 n8n: http://$(curl -s ifconfig.me)"
        ;;
    
    stop)
        echo "🛑 Deteniendo servicios..."
        docker-compose down
        echo "✅ Servicios detenidos"
        ;;
    
    restart)
        echo "🔄 Reiniciando servicios..."
        docker-compose down
        docker-compose up -d
        echo "✅ Servicios reiniciados"
        ;;
    
    status)
        echo "📊 Estado de los servicios:"
        docker-compose ps
        ;;
    
    logs)
        echo "📋 Logs de los servicios:"
        docker-compose logs -f --tail=50
        ;;
    
    update)
        echo "⬆️ Actualizando imágenes..."
        docker-compose pull
        docker-compose up -d
        echo "✅ Actualización completada"
        ;;
    
    backup)
        echo "💾 Creando backup manual..."
        docker-compose exec postgres pg_dump -U n8n -d n8n > "backups/manual_backup_$(date +%Y%m%d_%H%M%S).sql"
        echo "✅ Backup creado en directorio backups/"
        ;;
    
    install-mistral)
        echo "🧠 Instalando modelo Mistral 7B..."
        docker exec agente_ollama_1 ollama pull mistral:7b
        echo "✅ Mistral 7B instalado"
        ;;
    
    test-ollama)
        echo "🧪 Probando Ollama..."
        docker exec agente_ollama_1 ollama run mistral:7b "Hola, soy tu asistente personal. ¿Cómo puedo ayudarte?"
        ;;
    
    clean)
        echo "🧹 Limpiando contenedores y volúmenes no utilizados..."
        docker system prune -f
        echo "✅ Limpieza completada"
        ;;
    
    reset)
        echo "⚠️  ADVERTENCIA: Esto eliminará TODOS los datos."
        read -p "¿Estás seguro? (escribe 'RESET' para confirmar): " confirm
        if [ "$confirm" = "RESET" ]; then
            docker-compose down -v
            docker system prune -af
            echo "✅ Sistema reseteado completamente"
        else
            echo "❌ Reset cancelado"
        fi
        ;;
    
    monitor)
        echo "📈 Monitoreo en tiempo real (Ctrl+C para salir):"
        watch -n 2 'docker stats --no-stream'
        ;;
    
    *)
        echo "🤖 Agente Asistente Personal - Script de Gestión"
        echo ""
        echo "Uso: $0 [comando]"
        echo ""
        echo "Comandos disponibles:"
        echo "  start          - Iniciar todos los servicios"
        echo "  stop           - Detener todos los servicios"
        echo "  restart        - Reiniciar todos los servicios"
        echo "  status         - Ver estado de los servicios"
        echo "  logs           - Ver logs en tiempo real"
        echo "  update         - Actualizar imágenes Docker"
        echo "  backup         - Crear backup manual"
        echo "  install-mistral- Instalar modelo Mistral 7B"
        echo "  test-ollama    - Probar funcionamiento de Ollama"
        echo "  clean          - Limpiar contenedores no utilizados"
        echo "  reset          - RESETEAR todo (elimina datos)"
        echo "  monitor        - Monitoreo de recursos en tiempo real"
        echo ""
        echo "Ejemplos:"
        echo "  $0 start"
        echo "  $0 logs"
        echo "  $0 backup"
        ;;
esac
