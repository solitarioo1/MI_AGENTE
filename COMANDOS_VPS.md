# COMANDOS PARA EJECUTAR EN TU VPS
# Copiar y pegar estos comandos uno por uno en tu terminal SSH

# 1. Primero, hacer backup de la configuración actual
cp docker-compose.yml docker-compose.yml.backup
cp nginx.conf nginx.conf.backup

# 2. Descargar archivos actualizados desde GitHub (si ya hiciste push)
git pull origin main

# 3. O si prefieres, actualizar manualmente el docker-compose.yml
# Agregar estas líneas en la sección environment de n8n:
#      - N8N_PROXY_HOPS=1
#      - N8N_SERVE_FRONTEND=true  
#      - N8N_SKIP_WEBHOOK_DEREGISTRATION_SHUTDOWN=true

# 4. Detener y limpiar contenedores actuales
docker-compose down
docker system prune -f

# 5. Eliminar volumen de n8n para forzar recreación
docker volume rm mi_agente_n8n_data

# 6. Iniciar servicios nuevamente
docker-compose up -d

# 7. Monitorear logs de n8n
docker-compose logs -f n8n

# 8. En otra terminal, verificar que todos los servicios estén corriendo
docker-compose ps

# DIAGNÓSTICO ADICIONAL:
# Si sigue fallando, ejecutar estos comandos para diagnóstico:

# Ver logs detallados de nginx
docker-compose logs nginx

# Verificar conectividad interna
docker-compose exec nginx wget -qO- http://n8n:5678/healthz

# Verificar variables de entorno de n8n
docker-compose exec n8n env | grep N8N

# ACCESO FINAL:
# Después de estos pasos, acceder a:
# https://miagentepersonal.me:8443

# NOTA IMPORTANTE:
# El problema de pantalla negra generalmente se debe a:
# 1. Headers de proxy incorrectos
# 2. Variables de entorno de n8n mal configuradas  
# 3. Caché corrupto de n8n
# 4. Problemas con archivos estáticos CSS/JS

# Si después de esto sigue fallando, el problema podría ser:
# - Certificados SSL
# - Firewall bloqueando conexiones internas
# - Problema con el DNS/proxy de Cloudflare