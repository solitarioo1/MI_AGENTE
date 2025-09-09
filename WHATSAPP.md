# WhatsApp con Baileys (100% Gratuito y Open Source)

## 🎯 Configuración WhatsApp

### Baileys vs Twilio
- ✅ **Baileys**: Gratuito, ilimitado, open source
- ❌ **Twilio**: Ahora cobra por mensajes

### Instalación
```bash
# Baileys ya está incluido en n8n por defecto
# Solo necesitas configurar la sesión
```

### Configuración en n8n

1. **Crear Workflow WhatsApp**
2. **Nodo WhatsApp (Baileys)**
3. **Configurar credenciales:**
   - Session ID: `agente_session`
   - Webhook Secret: `tu_webhook_secret`

### Variables .env
```bash
WHATSAPP_SESSION_ID=agente_session
WHATSAPP_WEBHOOK_SECRET=tu_secret_aqui
```

### Primer Uso
1. **Escanear QR**: Al iniciar por primera vez
2. **Vincular WhatsApp Web**: Con tu teléfono
3. **Sesión persistente**: Se guarda automáticamente

### Ventajas Baileys
- 🆓 Completamente gratuito
- 📱 Usa WhatsApp Web oficial
- 💾 Sesiones persistentes
- 🔄 Reconexión automática
- 📨 Mensajes multimedia
- 👥 Grupos y contactos

### APIs Disponibles
- Enviar mensajes de texto
- Enviar imágenes/documentos
- Recibir mensajes
- Estados de entrega
- Información de contactos
- Gestión de grupos

## 🔧 Configuración Completa

El sistema usará Baileys automáticamente cuando configures WhatsApp en n8n. No necesitas servicios externos pagos.

**Resultado**: WhatsApp 100% gratuito e ilimitado ✅
