# WhatsApp con Evolution API (100% Gratuito y Robusto)

## 🎯 Configuración WhatsApp

### Evolution API vs Baileys
- ✅ **Evolution API**: Gratuito, robusto, API REST completa
- ✅ **Baileys**: Alternativa (mantenida como backup)

### Arquitectura Actual
```
Evolution API (Puerto 8080) ← → Nginx Proxy ← → n8n
     ↓
File Server Dummy (Interno)
```

## 🚀 **URLs de Acceso**

### **Acceso Directo (Para testing)**
- **Evolution API**: `http://miagentepersonal.me:8090/evolution/`
- **Manager**: `http://miagentepersonal.me:8090/evolution/manager`
- **API Docs**: `http://miagentepersonal.me:8090/evolution/docs`

### **HTTPS (Producción)**
- **Evolution API**: `https://miagentepersonal.me:8443/evolution/`
- **Manager**: `https://miagentepersonal.me:8443/evolution/manager`

## ⚙️ **Configuración Actual**

### Variables Configuradas (docker-compose.yml)
```yaml
environment:
  - AUTHENTICATION_TYPE=apikey
  - AUTHENTICATION_API_KEY=evolution-api-key
  - WEBHOOK_GLOBAL_URL=https://miagentepersonal.me:8443/evolution/webhook
  - FILE_SERVER_ENABLED=false
  - PROVIDER_FILES_ENABLED=false
  - FILES_ENABLED=false
```

### Credenciales de Acceso
- **API Key**: `evolution-api-key`
- **Base URL**: `https://miagentepersonal.me:8443/evolution`

## 📱 **Primer Uso - Crear Instancia**

### 1. Acceder al Manager
```bash
# Abrir en navegador:
https://miagentepersonal.me:8443/evolution/manager
```

### 2. Crear Nueva Instancia
```json
POST /evolution/instance/create
{
  "instanceName": "agente-personal",
  "token": "evolution-api-key",
  "qrcode": true,
  "webhookUrl": "https://miagentepersonal.me:8443/webhook/whatsapp"
}
```

### 3. Escanear QR Code
- Se genera automáticamente
- Escanear con WhatsApp
- Conexión persistente

## 🔧 **APIs Disponibles**

### **Gestión de Instancias**
```bash
# Crear instancia
POST /evolution/instance/create

# Estado de instancia  
GET /evolution/instance/connectionState/{instanceName}

# QR Code
GET /evolution/instance/qrcode/{instanceName}
```

### **Envío de Mensajes**
```bash
# Mensaje de texto
POST /evolution/message/sendText/{instanceName}
{
  "number": "5500000000000",
  "textMessage": {
    "text": "Hola desde Evolution API!"
  }
}

# Mensaje multimedia
POST /evolution/message/sendMedia/{instanceName}
```

### **Webhooks (Recibir Mensajes)**
- **URL**: `https://miagentepersonal.me:8443/evolution/webhook`
- **Eventos**: messages, connection_update, qrcode_update

## 🛠️ **Comandos de Testing**

### **Verificar Estado**
```bash
# Verificar conexión Evolution API
curl -X GET "https://miagentepersonal.me:8443/evolution/instance/connectionState/agente-personal" \
  -H "apikey: evolution-api-key"

# Health check
curl https://miagentepersonal.me:8443/health
```

### **Crear Instancia via API**
```bash
curl -X POST "https://miagentepersonal.me:8443/evolution/instance/create" \
  -H "apikey: evolution-api-key" \
  -H "Content-Type: application/json" \
  -d '{
    "instanceName": "agente-personal",
    "qrcode": true,
    "webhookUrl": "https://miagentepersonal.me:8443/webhook/whatsapp"
  }'
```

## 🔍 **Troubleshooting**

### **Error: "No se puede acceder a este sitio"**
```bash
# 1. Verificar servicios
docker-compose ps

# 2. Ver logs Evolution API
docker-compose logs evolution-api

# 3. Verificar nginx proxy
docker-compose logs nginx

# 4. Test interno
docker-compose exec nginx curl -f http://evolution-api:8080/
```

### **Soluciones Comunes**
1. **Evolution API no inicia**: Verificar variables de entorno
2. **Nginx no proxy**: Revisar configuración `/evolution/` route  
3. **File server error**: Dummy está configurado correctamente
4. **Puerto ocupado**: Evolution API usa puerto interno 8080

## 🔥 **Ventajas vs Baileys**

| Característica | Evolution API | Baileys |
|---------------|---------------|---------|
| **API REST** | ✅ Completa | ❌ Limitada |
| **Manager Web** | ✅ Incluido | ❌ No |
| **Multi-instancia** | ✅ Sí | ❌ No |
| **Webhooks** | ✅ Robusto | ✅ Básico |
| **Documentación** | ✅ Excelente | ✅ Básica |
| **Estabilidad** | ✅ Alta | ✅ Buena |

## 📊 **Monitoreo**

### **Logs Evolution API**
```bash
# Ver logs en tiempo real
docker-compose logs -f evolution-api

# Ver últimas 50 líneas
docker-compose logs --tail=50 evolution-api
```

### **Health Checks Configurados**
- **Evolution API**: `curl -f http://localhost:8080/`
- **Intervalo**: 30 segundos
- **Reinicio automático**: Si falla health check

**Resultado**: WhatsApp 100% gratuito con API REST profesional ✅
