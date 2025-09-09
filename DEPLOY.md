# Guía de Despliegue en VPS

## 📋 Pre-requisitos en tu VPS

### Sistema Operativo
- Ubuntu 20.04 LTS o superior
- Debian 10 o superior
- Mínimo 4GB RAM, 2 vCPU
- 20GB espacio libre

### Puertos necesarios
- 22 (SSH)
- 80 (HTTP)
- 443 (HTTPS - opcional)

## 🚀 Instalación Paso a Paso

### 1. Subir archivos al VPS

```bash
# Opción A: Con rsync (recomendado)
rsync -avz --exclude 'node_modules' ./ usuario@tu-vps-ip:/home/usuario/agente/

# Opción B: Con SCP
scp -r ./ usuario@tu-vps-ip:/home/usuario/agente/

# Opción C: Con Git (si tienes repositorio)
git clone https://github.com/tu-usuario/agente.git
cd agente
```

### 2. Configurar variables de entorno

```bash
# Editar .env con tus datos
nano .env

# Cambiar al menos:
WEBHOOK_URL=http://TU-IP-VPS
DB_PASSWORD=tu_password_seguro
N8N_ENCRYPTION_KEY=clave_super_segura_aqui
```

### 3. Ejecutar instalación automática

```bash
# Dar permisos
chmod +x scripts/install.sh
chmod +x scripts/manage.sh

# Ejecutar instalación
./scripts/install.sh
```

### 4. Iniciar servicios

```bash
# Opción A: Manual
docker-compose up -d

# Opción B: Con script
./scripts/manage.sh start
```

### 5. Instalar modelo de IA

```bash
# Instalar Mistral 7B
./scripts/manage.sh install-mistral

# Verificar instalación
./scripts/manage.sh test-ollama
```

## ⚙️ Configuración Post-Instalación

### Acceder a n8n
- URL: `http://TU-IP-VPS`
- Usuario: `admin`
- Contraseña: `admin123` (cambiar en .env)

### Configurar APIs Externas

1. **Google APIs**
   - Ve a [Google Cloud Console](https://console.cloud.google.com/)
   - Activa: Calendar API, Sheets API, Gmail API
   - Crea credenciales OAuth 2.0
   - Descarga el archivo JSON

2. **WhatsApp (Twilio)**
   - Regístrate en [Twilio](https://www.twilio.com/)
   - Configura WhatsApp Sandbox
   - Obtén Account SID y Auth Token

## 🔧 Comandos Útiles

```bash
# Ver estado
./scripts/manage.sh status

# Ver logs
./scripts/manage.sh logs

# Backup manual
./scripts/manage.sh backup

# Actualizar
./scripts/manage.sh update

# Reiniciar
./scripts/manage.sh restart

# Monitor recursos
./scripts/manage.sh monitor
```

## 🛡️ Seguridad

### Firewall
```bash
# UFW (Ubuntu/Debian) 
sudo ufw allow 22/tcp
sudo ufw allow 8090/tcp  # HTTP custom port
sudo ufw allow 8443/tcp  # HTTPS custom port
sudo ufw enable
```

### SSL/HTTPS (Opcional)
```bash
# Instalar Certbot
sudo apt install certbot

# Obtener certificado
sudo certbot certonly --standalone -d tu-dominio.com

# Copiar certificados
sudo cp /etc/letsencrypt/live/tu-dominio.com/fullchain.pem ssl/cert.pem
sudo cp /etc/letsencrypt/live/tu-dominio.com/privkey.pem ssl/key.pem
sudo chown $USER:$USER ssl/*.pem

# Descomentar configuración HTTPS en nginx.conf
```

## 📊 Monitoreo

### Verificar salud de servicios
```bash
# Todos los servicios
docker-compose ps

# Logs específicos
docker-compose logs n8n
docker-compose logs ollama
docker-compose logs postgres
```

### Recursos del sistema
```bash
# Uso de memoria
free -h

# Uso de CPU
top

# Espacio en disco
df -h

# Monitor Docker
docker stats
```

## 🔥 Troubleshooting

### Problemas comunes

1. **Ollama no responde**
   ```bash
   docker-compose restart ollama
   ./scripts/manage.sh install-mistral
   ```

2. **n8n no carga**
   ```bash
   docker-compose logs n8n
   # Verificar variables .env
   ```

3. **Memoria insuficiente**
   ```bash
   # Agregar swap
   sudo fallocate -l 2G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   ```

4. **Puerto ocupado**
   ```bash
   # Ver qué usa el puerto 80
   sudo lsof -i :80
   
   # Matar proceso si es necesario
   sudo kill -9 PID
   ```

### Logs útiles
```bash
# Todos los logs
docker-compose logs -f

# Solo errores
docker-compose logs | grep -i error

# Últimas 100 líneas
docker-compose logs --tail=100
```

## 🔄 Mantenimiento

### Backups automáticos
- Se crean cada 24 horas
- Se guardan en `/backups/`
- Se eliminan automáticamente después de 7 días

### Actualizaciones
```bash
# Actualizar imágenes
./scripts/manage.sh update

# Actualizar sistema
sudo apt update && sudo apt upgrade -y
```

### Limpieza
```bash
# Limpiar Docker
./scripts/manage.sh clean

# Limpiar logs viejos
sudo find /var/log -name "*.log" -mtime +30 -delete
```

## 🎯 URLs de Acceso

Una vez instalado:
- **n8n Interface**: `http://TU-IP-VPS`
- **Ollama API**: `http://TU-IP-VPS/ollama`
- **Health Check**: `http://TU-IP-VPS/health`

## 📞 Soporte

Si tienes problemas:
1. Revisa los logs: `./scripts/manage.sh logs`
2. Verifica el estado: `./scripts/manage.sh status`
3. Consulta la documentación: `README.md`
