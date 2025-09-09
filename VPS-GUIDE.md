# 🤖 Guía de Despliegue VPS - Agente Asistente Personal

> Basado en tu experiencia previa con conexionVPS

## 🎯 **DIFERENCIAS CON TU PROYECTO ANTERIOR**

| Aspecto | Proyecto Web Simple | Agente IA |
|---------|-------------------|-----------|
| **Servicios** | 1 contenedor (Nginx) | 5 contenedores (n8n, PostgreSQL, Ollama, Nginx, Backup) |
| **Puerto** | 8080 | 8090 (HTTP), 8443 (HTTPS) |
| **Complejidad** | HTML estático | IA + Base datos + APIs |
| **Memoria** | ~50MB | ~2.3GB |
| **Configuración** | Mínima | Variables .env + APIs |

## 🚀 **PROCESO OPTIMIZADO (Basado en tu experiencia)**

### **1. Preparar archivos localmente (YA LISTO ✅)**
```bash
# Estructura creada:
MI_agente/
├── docker-compose.yml    # Como tu proyecto anterior pero multi-servicio
├── .env                  # Variables (similar a tu approach)
├── nginx.conf            # Proxy (más complejo que tu web estática)
├── scripts/              # Automatización (nuevo)
└── DEPLOY.md            # Guía paso a paso
```

### **2. Subir a GitHub (Igual que tu proceso)**
```bash
git init
git add .
git commit -m "Agente IA asistente personal v1.0"
git remote add origin https://github.com/tu-usuario/agente-ia.git
git push -u origin main
```

### **3. Conexión VPS (Igual que usaste)**
```bash
ssh usuario@172.206.16.218
```

### **4. Instalación en VPS (Mejorado vs tu proceso)**
```bash
# Tu proceso anterior era:
# sudo apt install docker.io docker-compose -y
# git clone repo
# sudo docker-compose up -d

# NUESTRO PROCESO (más automatizado):
git clone https://github.com/tu-usuario/agente-ia.git
cd agente-ia
chmod +x scripts/*.sh
./scripts/install.sh      # Instala Docker automáticamente
./scripts/generate-ssl.sh # Genera SSL
nano .env                 # Configurar variables
./scripts/manage.sh start # Iniciar servicios
```

### **5. Configurar Azure NSG (Similar a tu experiencia)**
```bash
# En Azure Portal → Tu VPS → Networking → Add inbound rules:

# Regla 1:
- Puertos destino: 8090
- Protocolo: TCP
- Acción: Permitir
- Nombre: Allow-Agente-HTTP

# Regla 2:
- Puertos destino: 8443
- Protocolo: TCP  
- Acción: Permitir
- Nombre: Allow-Agente-HTTPS
```

## 🔧 **COMANDOS ÚTILES (Adaptados de tu experiencia)**

### **Gestión (Como tu docker-compose pero más fácil)**
```bash
# Tu forma anterior:
# sudo docker-compose up -d
# sudo docker-compose logs
# sudo docker-compose down

# NUESTRA FORMA (con scripts):
./scripts/manage.sh start     # = docker-compose up -d
./scripts/manage.sh logs      # = docker-compose logs -f
./scripts/manage.sh stop      # = docker-compose down
./scripts/manage.sh status    # = docker ps
./scripts/manage.sh backup    # Backup automático
./scripts/manage.sh restart   # Reinicio completo
```

### **Verificación de salud (Como tu proyecto)**
```bash
# Estado de contenedores
./scripts/manage.sh status

# Logs en tiempo real
./scripts/manage.sh logs

# Verificar conectividad
curl http://172.206.16.218:8090/health
```

## 🔥 **MEJORAS vs TU PROYECTO ANTERIOR**

### **✅ Automatización avanzada:**
- Script de instalación automática
- Generación SSL automática
- Gestión con comandos simples
- Backups automáticos

### **✅ Mejor monitoreo:**
- Health checks de todos los servicios
- Logs centralizados
- Monitor de recursos

### **✅ Seguridad mejorada:**
- HTTPS por defecto
- Variables en .env
- Certificados SSL incluidos

### **✅ Escalabilidad:**
- Multi-contenedor coordinado
- Límites de memoria
- Restart automático

## 🌐 **ACCESO FINAL**

```bash
# Tu proyecto anterior:
http://172.206.16.218:8080

# NUESTRO AGENTE:
https://172.206.16.218:8443  # HTTPS principal
http://172.206.16.218:8090   # HTTP alternativo
```

## 🛠️ **TROUBLESHOOTING (Basado en tu experiencia)**

### **Puerto ocupado (Como solucionaste antes)**
```bash
# Verificar puertos
sudo lsof -i :8090
sudo lsof -i :8443

# Si están ocupados, cambiar en docker-compose.yml:
ports:
  - "8091:80"   # Cambiar 8090 → 8091
  - "8444:443"  # Cambiar 8443 → 8444
```

### **Firewall/NSG (Mismo proceso que usaste)**
```bash
# Ubuntu UFW
sudo ufw allow 8090
sudo ufw allow 8443
sudo ufw status

# Azure NSG - Mismo proceso que ya conoces
```

### **Verificar funcionamiento**
```bash
# Estado contenedores (como tu comando)
sudo docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Logs específicos
./scripts/manage.sh logs n8n
./scripts/manage.sh logs ollama
```

## 🎯 **MIGRACIÓN DESDE TU EXPERIENCIA**

```bash
# 1. Usa el mismo flujo que ya conoces:
ssh → git clone → configurar → docker up

# 2. Pero con más servicios coordinados:
- En lugar de 1 contenedor → 5 contenedores
- En lugar de HTML estático → IA + Base datos
- En lugar de configuración mínima → .env completo

# 3. Mismos principios, mayor potencia:
- Docker Compose ✅ (ya lo conoces)
- Nginx proxy ✅ (ya lo usaste)
- Health checks ✅ (mejorados)
- Port mapping ✅ (puertos personalizados)
```

## 🚀 **SIGUIENTE PASO RECOMENDADO**

Como ya tienes experiencia con VPS + Docker, te sugiero:

1. **Subir a GitHub** (como hiciste antes)
2. **Clonar en VPS** (mismo proceso)
3. **Ejecutar instalación automática** (más simple que antes)
4. **Configurar variables** (nuevo paso)
5. **Iniciar servicios** (como antes pero coordinados)

**¿Te parece bien este approach basado en tu experiencia previa?** 🤔
