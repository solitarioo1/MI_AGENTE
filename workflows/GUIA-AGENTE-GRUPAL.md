# 🤖 **AGENTE GRUPAL WHATSAPP - GUÍA COMPLETA**

> Workflow de n8n para gestión inteligente de reuniones grupales via WhatsApp

## 🎯 **FUNCIONALIDADES**

### **👥 Comandos Grupales**
- **Consulta:** `@agente pendientes` / `@agente reuniones`
- **Agendar:** `@agente agendar reunión viernes 3pm presupuesto`
- **Modificar:** `@agente mover reunión viernes→jueves`
- **Borrar:** `@agente cancelar reunión viernes`
- **Email:** `@agente enviar invitación localintento@gmail.com`

### **🧠 Procesamiento Inteligente**
- **Extracción de fechas:** viernes, mañana, 15/09, etc.
- **Detección de emails:** automática en comandos
- **Identificación de usuarios:** por nombre y teléfono
- **Contexto grupal:** mantiene historial por grupo

---

## 📊 **ESTRUCTURA DE BASE DE DATOS**

### **Tabla: grupos**
```sql
CREATE TABLE grupos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    chat_id VARCHAR(50) UNIQUE,
    miembros TEXT[],
    created_at TIMESTAMP DEFAULT NOW()
);
```

### **Tabla: reuniones**
```sql
CREATE TABLE reuniones (
    id SERIAL PRIMARY KEY,
    grupo_id INTEGER REFERENCES grupos(id),
    titulo VARCHAR(200),
    fecha DATE,
    hora TIME,
    creador VARCHAR(100),
    participantes TEXT[],
    emails_invitados TEXT[],
    estado VARCHAR(20) DEFAULT 'programada',
    meet_link TEXT,
    calendar_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT NOW()
);
```

### **Tabla: comandos_log**
```sql
CREATE TABLE comandos_log (
    id SERIAL PRIMARY KEY,
    usuario VARCHAR(100),
    grupo_id INTEGER REFERENCES grupos(id),
    comando TEXT,
    accion VARCHAR(50),
    exito BOOLEAN,
    timestamp TIMESTAMP DEFAULT NOW()
);
```

---

## 🔧 **CONFIGURACIÓN PREVIA**

### **1. Credenciales Necesarias**
- **PostgreSQL:** Conexión a base de datos
- **Google Calendar API:** OAuth2 para crear eventos
- **Gmail API:** OAuth2 para enviar invitaciones
- **WhatsApp API:** Webhook para envío de mensajes

### **2. Variables de Entorno**
```env
# En tu .env
WHATSAPP_WEBHOOK_URL=http://localhost:8080/webhook/whatsapp-send
OLLAMA_URL=http://ollama:11434
```

### **3. Configurar Webhook WhatsApp**
```bash
# URL del webhook en n8n
https://miagentepersonal.me:8443/webhook/agente-whatsapp
```

---

## 🚀 **FLUJO DE TRABAJO**

### **📱 1. Recepción de Mensaje**
```javascript
// Webhook recibe mensaje de WhatsApp
{
  "body": {
    "message": {
      "body": "@agente agendar reunión viernes 3pm",
      "from": "5551234567@c.us",
      "chatId": "grupo-trabajo@g.us",
      "notifyName": "Carlos"
    }
  }
}
```

### **🔍 2. Filtrado y Procesamiento**
```javascript
// Detecta menciones @agente
if (mensaje.includes('@agente')) {
  // Procesa comando
  const comando = mensaje.replace('@agente', '').trim();
  
  // Extrae información
  const datos = {
    usuario: 'Carlos',
    tipoComando: 'agendar',
    fechaDetectada: 'viernes',
    emails: ['localintento@gmail.com']
  };
}
```

### **🧠 3. Procesamiento con IA**
```javascript
// Ollama Mistral extrae datos estructurados
const prompt = `
Usuario Carlos quiere agendar: 'reunión viernes 3pm presupuesto'
Extrae: título, fecha, hora, participantes
Formato JSON: {"titulo": "", "fecha": "YYYY-MM-DD", "hora": "HH:MM"}
`;
```

### **💾 4. Persistencia de Datos**
```sql
-- Guarda reunión en PostgreSQL
INSERT INTO reuniones (grupo_id, titulo, fecha, hora, creador) 
VALUES (1, 'Reunión Presupuesto', '2025-09-20', '15:00', 'Carlos');
```

### **📅 5. Integración con Google Calendar**
```javascript
// Crea evento automáticamente
{
  "summary": "Reunión Presupuesto",
  "start": {"dateTime": "2025-09-20T15:00:00"},
  "end": {"dateTime": "2025-09-20T16:00:00"},
  "description": "Creado por Carlos via AgenteBOT"
}
```

### **📧 6. Envío de Invitaciones**
```html
<!-- Email automático -->
<h2>Nueva Reunión Programada</h2>
<p><strong>Título:</strong> Reunión Presupuesto</p>
<p><strong>Fecha:</strong> 20/09/2025</p>
<p><strong>Hora:</strong> 15:00</p>
<p><strong>Link Meet:</strong> https://meet.google.com/xxx</p>
```

### **💬 7. Respuesta en WhatsApp**
```text
✅ Carlos, reunión agendada exitosamente:

📅 **Reunión Presupuesto**
🕒 20/09/2025 a las 15:00
👥 Participantes: Equipo completo
📧 Emails enviados: 2 personas
🔗 Link Meet: https://meet.google.com/xxx
```

---

## 📋 **COMANDOS SOPORTADOS**

### **🔍 Consultas**
```text
@agente pendientes
@agente reuniones esta semana
@agente qué tengo mañana
@agente calendario
```

### **📅 Agendar**
```text
@agente agendar reunión viernes 3pm presupuesto
@agente crear evento mañana 10am con equipo marketing
@agente programar junta jueves 2pm + email carlos@empresa.com
```

### **✏️ Modificar**
```text
@agente mover reunión viernes→jueves
@agente cambiar hora reunión presupuesto 4pm
@agente reprogramar junta para lunes
```

### **🗑️ Borrar**
```text
@agente cancelar reunión viernes
@agente eliminar evento presupuesto
@agente borrar junta jueves
```

---

## 🛠️ **INSTALACIÓN**

### **1. Importar Workflow**
1. Accede a n8n: `https://miagentepersonal.me:8443`
2. Click "Import from file"
3. Selecciona `agente-grupal-workflow.json`
4. Activa el workflow

### **2. Configurar Credenciales**
```bash
# PostgreSQL
Host: postgres
Database: n8n
User: n8n
Password: (tu password del .env)

# Google Calendar
OAuth2: https://console.cloud.google.com/apis/credentials

# Gmail
OAuth2: https://console.cloud.google.com/apis/credentials
```

### **3. Crear Tablas**
```sql
-- Conecta a PostgreSQL y ejecuta:
\i scripts/database-schema.sql
```

### **4. Configurar WhatsApp**
```bash
# Configura webhook en tu API de WhatsApp
curl -X POST "https://tu-whatsapp-api.com/webhook" \
  -d "url=https://miagentepersonal.me:8443/webhook/agente-whatsapp"
```

### **5. Probar Sistema**
```text
# En tu grupo de WhatsApp
@agente pendientes
```

---

## 🔍 **DEBUGGING & LOGS**

### **Ver Logs de Ejecución**
```bash
# Logs de n8n
docker logs mi_agente_n8n_1 --tail=50 -f

# Logs de comandos en DB
SELECT * FROM comandos_log ORDER BY timestamp DESC LIMIT 10;
```

### **Verificar Conexiones**
```bash
# Test PostgreSQL
docker exec mi_agente_n8n_1 psql -h postgres -U n8n -d n8n -c "SELECT 1;"

# Test Ollama
curl http://localhost:11434/api/generate -d '{"model":"mistral","prompt":"test"}'
```

### **Troubleshooting Común**
- **WhatsApp no responde:** Verificar webhook URL
- **IA no extrae datos:** Revisar prompt de Ollama
- **Calendar no crea eventos:** Verificar OAuth2 tokens
- **Emails no se envían:** Verificar credenciales Gmail

---

## 🎯 **CASOS DE USO REALES**

### **Escenario 1: Reunión Urgente**
```text
Carlos: @agente agendar reunión urgente mañana 9am crisis presupuesto
```
**Resultado:** Evento creado, emails enviados, respuesta inmediata

### **Escenario 2: Modificación de Última Hora**
```text
Luis: @agente mover reunión viernes→jueves + avisar a localintento@gmail.com
```
**Resultado:** Reunión reprogramada, calendar actualizado, email enviado

### **Escenario 3: Consulta Grupal**
```text
Moisés: @agente qué reuniones tenemos esta semana
```
**Resultado:** Lista completa con fechas, horarios y participantes

---

## ⚡ **OPTIMIZACIONES**

### **Performance**
- **Índices DB:** CREATE INDEX ON reuniones(grupo_id, fecha);
- **Cache Ollama:** Mantener modelo cargado
- **Webhook Queue:** Evitar timeouts en WhatsApp

### **Seguridad**
- **Validación:** Solo usuarios autorizados pueden agendar
- **Rate Limiting:** Máximo 10 comandos por usuario/hora
- **Sanitización:** Limpiar inputs antes de DB

### **Escalabilidad**
- **Multi-grupo:** Soporte para múltiples grupos
- **Multi-idioma:** Detección automática de idioma
- **APIs externas:** Zoom, Teams, Slack integration

---

## 🚀 **PRÓXIMAS FUNCIONALIDADES**

- [ ] **Recordatorios automáticos** (15 min antes)
- [ ] **Confirmación de asistencia** via reacciones
- [ ] **Integración con Zoom/Teams** para videollamadas
- [ ] **Reportes semanales** de reuniones
- [ ] **IA más avanzada** para contexto conversacional
- [ ] **Multi-idioma** (inglés, portugués)
- [ ] **API REST** para integraciones externas

---

**✅ WORKFLOW PRODUCTION-READY**
**🤖 AGENTE INTELIGENTE LISTO PARA TU GRUPO**