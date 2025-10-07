# 🚀 **GUÍA DE ACCESO - Evolution API**

## 🎯 **URLs DE ACCESO CORREGIDAS**

### **Acceso Directo (Para desarrollo/testing)**
```
HTTP:  http://miagentepersonal.me:8080/
HTTPS: http://miagentepersonal.me:8080/ (directo, sin proxy)
```

### **Acceso vía Proxy Nginx (Producción)**  
```
HTTP:  http://miagentepersonal.me:8090/evolution/
HTTPS: https://miagentepersonal.me:8443/evolution/
```

## 🔧 **COMANDOS DE VERIFICACIÓN**

### **1. Verificar que Evolution API esté funcionando**
```bash
# Desde el VPS
curl -f http://localhost:8080/

# Desde fuera (acceso directo)
curl -f http://miagentepersonal.me:8080/

# Vía proxy nginx
curl -f http://miagentepersonal.me:8090/evolution/
```

### **2. Ver logs si no funciona**
```bash
# Ver logs Evolution API
docker-compose logs evolution-api

# Ver logs Nginx
docker-compose logs nginx

# Ver estado de contenedores
docker-compose ps
```

### **3. Comandos de troubleshooting**
```bash
# Reiniciar Evolution API específicamente
docker-compose restart evolution-api

# Verificar conectividad interna
docker-compose exec nginx curl -f http://evolution-api:8080/

# Ver configuración de red
docker network ls
docker network inspect mi_agente_default
```

## 🔍 **SOLUCIONES A PROBLEMAS COMUNES**

### **Problema 1: "No se puede acceder a este sitio"**

**Causa**: Evolution API no está exponiendo el puerto o no inició correctamente

**Solución**:
```bash
# Verificar si Evolution API está corriendo
docker-compose ps | grep evolution

# Si no está corriendo, revisar logs
docker-compose logs evolution-api

# Reiniciar si es necesario
docker-compose restart evolution-api
```

### **Problema 2: "Connection refused" en puerto 8080**

**Causa**: Conflicto de puertos (como vimos antes)

**Solución**: 
- ✅ **YA CORREGIDO**: Ahora Evolution API tiene mapeo de puerto directo
- El dummy file server no expone puerto (solo interno)

### **Problema 3: Nginx proxy no funciona**

**Causa**: Configuración de rutas nginx incorrecta

**Verificación**:
```bash
# Probar acceso interno
docker-compose exec nginx curl -f http://evolution-api:8080/

# Si funciona interno pero no externo, problema es nginx config
# Si no funciona interno, problema es Evolution API
```

## ✅ **CONFIGURACIÓN CORREGIDA**

### **Docker Compose (Actualizado)**
- ✅ Evolution API expone puerto 8080 directamente
- ✅ File server dummy solo interno (sin conflictos)
- ✅ Evolution API depende del dummy para evitar errores

### **Nginx (Ya configurado)**
- ✅ Proxy `/evolution/` → `http://evolution-api:8080/`
- ✅ Headers correctos para WebSocket
- ✅ Timeouts apropiados

### **Variables de Entorno (Correctas)**
- ✅ `PROVIDER_HOST=file-server-dummy` (interno)
- ✅ `FILE_SERVER_ENABLED=false` (deshabilitado)
- ✅ `WEBHOOK_GLOBAL_URL` apunta a nginx

## 🎯 **PRÓXIMOS PASOS**

### **1. Hacer push de cambios**
```bash
git add .
git commit -m "fix: Exponer puerto Evolution API y actualizar documentación"
git push origin main
```

### **2. Deploy en VPS**
```bash
# En el VPS
cd ~/MI_AGENTE
git pull origin main
docker-compose down
docker-compose up -d
```

### **3. Verificar funcionamiento**
```bash
# Acceso directo
curl http://miagentepersonal.me:8080/

# Acceso vía proxy
curl http://miagentepersonal.me:8090/evolution/
```

### **4. Crear primera instancia WhatsApp**
```bash
# Abrir en navegador una vez que funcione:
http://miagentepersonal.me:8080/manager
```

## 📊 **URLs FINALES DE TRABAJO**

| Servicio | URL Directa | URL Proxy |
|----------|-------------|-----------|
| **Evolution API** | `http://miagentepersonal.me:8080/` | `http://miagentepersonal.me:8090/evolution/` |
| **Manager** | `http://miagentepersonal.me:8080/manager` | `http://miagentepersonal.me:8090/evolution/manager` |
| **API Docs** | `http://miagentepersonal.me:8080/docs` | `http://miagentepersonal.me:8090/evolution/docs` |
| **n8n** | - | `http://miagentepersonal.me:8090/` |

**¡Ahora deberías poder acceder sin problemas!** 🎉