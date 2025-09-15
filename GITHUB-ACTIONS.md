# 🚀 GitHub Actions - Deploy Automático

## 📋 Resumen

Este proyecto usa **GitHub Actions** para deploy automático. Cada vez que haces `git push` a la rama `main`, se ejecuta automáticamente el deploy en tu VPS.

## 🔧 Configuración Inicial

### 1. Configurar Secretos en GitHub

Ve a: `https://github.com/solitarioo1/MI_AGENTE/settings/secrets/actions`

Agrega estos secretos:

| Nombre | Valor | Descripción |
|--------|-------|-------------|
| `VPS_HOST` | `172.206.16.218` | IP de tu VPS Azure |
| `VPS_USER` | `SOLITARIOfeliz` | Usuario SSH del VPS |
| `VPS_SSH_KEY` | `[Clave SSH privada]` | Clave para autenticación |

### 2. Generar Clave SSH (si no tienes)

En tu VPS:
```bash
ssh-keygen -t rsa -b 4096 -C "github-actions"
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa  # Copiar al secret VPS_SSH_KEY
```

## ⚡ Flujo de Trabajo

### Desarrollo Local:
```bash
# 1. Desarrollar localmente
git add .
git commit -m "Nueva feature: agregar X funcionalidad"
git push origin main
```

### Deploy Automático:
1. 🔄 GitHub Actions detecta el push
2. 📥 Conecta al VPS por SSH
3. 📥 Descarga últimos cambios (`git pull`)
4. 🐳 Actualiza contenedores Docker
5. ✅ Verifica que todo funcione
6. 🎉 Deploy completado

## 📊 Monitoreo

### Ver Estado del Deploy:
- **GitHub Actions**: `https://github.com/solitarioo1/MI_AGENTE/actions`
- **VPS Health**: `https://miagentepersonal.me:8443/health`
- **Sitio Principal**: `https://miagentepersonal.me:8443`

### Logs en Tiempo Real:
```bash
# En el VPS (si necesitas debug):
docker-compose logs -f
```

## 🛠️ Comandos Útiles

### Ejecutar Deploy Manual:
```bash
# Desde GitHub → Actions → Run workflow
```

### Debug en VPS:
```bash
ssh SOLITARIOfeliz@172.206.16.218
cd ~/MI_AGENTE
docker-compose ps
docker-compose logs
```

### Rollback de Emergencia:
```bash
# En el VPS:
cd ~/MI_AGENTE
git log --oneline -5  # Ver commits anteriores
git checkout [commit-anterior]
docker-compose up -d
```

## 🔐 Seguridad

- ✅ **Secretos cifrados** en GitHub
- ✅ **SSH con clave** (no contraseña)
- ✅ **Variables sensibles** no se exponen
- ✅ **Backup automático** de .env

## 🎯 Beneficios

| Antes | Después |
|-------|---------|
| SSH manual al VPS | `git push` automático |
| `git pull` manual | Deploy automático |
| `docker-compose up` manual | Restart automático |
| Sin monitoreo | Logs en GitHub Actions |
| Errores silenciosos | Notificaciones de fallos |

## 🚨 Resolución de Problemas

### Si el deploy falla:
1. Ver logs en GitHub Actions
2. Verificar secretos configurados
3. Comprobar conectividad SSH
4. Revisar estado del VPS

### Si el sitio no responde:
1. Verificar contenedores: `docker-compose ps`
2. Ver logs: `docker-compose logs -f`
3. Probar health check: `curl http://localhost:8090/health`

---

**¡Ahora tu desarrollo es 100% profesional!** 🚀