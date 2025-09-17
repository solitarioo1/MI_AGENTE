const makeWASocket = require('baileys').default;
const { DisconnectReason, useMultiFileAuthState } = require('baileys');
const qrcode = require('qrcode-terminal');
const express = require('express');
const axios = require('axios');
const { Client } = require('pg');
const crypto = require('crypto');
require('dotenv').config();

const app = express();
app.use(express.json());

// Configuración desde variables de entorno
const config = {
    whatsappNumber: process.env.WHATSAPP_NUMBER,
    webhookUrl: process.env.WEBHOOK_URL || 'http://n8n:5678/webhook/whatsapp',
    authorizedGroups: (process.env.AUTHORIZED_GROUPS || '').split(',').filter(Boolean),
    database: {
        host: process.env.DB_HOST || 'postgres',
        user: process.env.DB_USER || 'n8n',
        password: process.env.DB_PASS || '',
        database: process.env.DB_NAME || 'n8n',
        port: process.env.DB_PORT || 5432
    }
};

let sock;
let isConnected = false;

// Cliente de base de datos
const dbClient = new Client(config.database);

// Conectar a base de datos
async function connectDB() {
    try {
        await dbClient.connect();
        console.log('✅ Conectado a PostgreSQL');
    } catch (error) {
        console.error('❌ Error conectando a BD:', error);
    }
}

// Función para enviar mensaje a n8n
async function sendToN8N(messageData) {
    try {
        await axios.post(config.webhookUrl, messageData, {
            headers: { 'Content-Type': 'application/json' },
            timeout: 10000
        });
        console.log('📤 Mensaje enviado a n8n');
    } catch (error) {
        console.error('❌ Error enviando a n8n:', error.message);
    }
}

// Función para procesar mensajes
async function processMessage(message) {
    const messageBody = message.message?.conversation || 
                       message.message?.extendedTextMessage?.text || '';
    
    // Solo procesar mensajes que empiecen con @agente
    if (!messageBody.startsWith('@agente')) {
        return;
    }

    // Verificar si es grupo autorizado
    const groupId = message.key.remoteJid;
    if (!config.authorizedGroups.includes(groupId)) {
        console.log(`⚠️ Grupo no autorizado: ${groupId}`);
        return;
    }

    // Ignorar mensajes del propio bot
    if (message.key.fromMe) {
        return;
    }

    // Extraer información del mensaje
    const sender = message.key.participant || message.key.remoteJid;
    const command = messageBody.replace('@agente', '').trim();
    
    const messageData = {
        messageId: message.key.id,
        from: sender,
        groupId: groupId,
        command: command,
        originalMessage: messageBody,
        timestamp: new Date().toISOString(),
        messageType: 'group'
    };

    console.log(`📨 Comando recibido: "${command}" de ${sender}`);
    
    // Enviar a n8n para procesamiento
    await sendToN8N(messageData);
    
    // Registrar en base de datos
    try {
        await dbClient.query(
            'INSERT INTO comandos_log (grupo_id, usuario_id, comando, timestamp) VALUES ($1, $2, $3, $4)',
            [groupId, sender, command, new Date()]
        );
    } catch (error) {
        console.error('❌ Error guardando en BD:', error);
    }
}

// Función para inicializar WhatsApp
async function startWhatsApp() {
    const { state, saveCreds } = await useMultiFileAuthState('./sessions');
    
    sock = makeWASocket({
        auth: state,
        printQRInTerminal: true,
        logger: require('pino')({ level: 'info' }),
        browser: ['MI_AGENTE', 'Chrome', '1.0.0'],
        generateHighQualityLinkPreview: true
    });

    sock.ev.on('creds.update', saveCreds);
    
    sock.ev.on('connection.update', (update) => {
        const { connection, lastDisconnect, qr } = update;
        
        if (qr) {
            console.log('📱 Escanea este código QR con WhatsApp:');
            qrcode.generate(qr, { small: true });
        }
        
        if (connection === 'close') {
            const shouldReconnect = (lastDisconnect?.error?.output?.statusCode !== DisconnectReason.loggedOut);
            console.log('🔄 Conexión cerrada, reconectando...', shouldReconnect);
            isConnected = false;
            
            if (shouldReconnect) {
                setTimeout(startWhatsApp, 5000);
            }
        } else if (connection === 'open') {
            console.log('✅ WhatsApp conectado exitosamente');
            isConnected = true;
        }
    });

    sock.ev.on('messages.upsert', async ({ messages }) => {
        for (const message of messages) {
            if (!message.key.fromMe && message.message) {
                await processMessage(message);
            }
        }
    });
}

// API endpoints
app.get('/health', (req, res) => {
    res.json({ 
        status: isConnected ? 'connected' : 'disconnected',
        timestamp: new Date().toISOString()
    });
});

app.post('/send', async (req, res) => {
    const { to, message } = req.body;
    
    try {
        if (!isConnected) {
            return res.status(503).json({ error: 'WhatsApp no conectado' });
        }
        
        await sock.sendMessage(to, { text: message });
        res.json({ success: true, message: 'Mensaje enviado' });
    } catch (error) {
        console.error('❌ Error enviando mensaje:', error);
        res.status(500).json({ error: 'Error enviando mensaje' });
    }
});

// Iniciar servicios
async function init() {
    console.log('🚀 Iniciando WhatsApp Bot...');
    
    // Conectar a base de datos
    await connectDB();
    
    // Iniciar WhatsApp
    await startWhatsApp();
    
    // Iniciar servidor HTTP
    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
        console.log(`🌐 Servidor HTTP ejecutándose en puerto ${PORT}`);
        console.log(`📋 Grupos autorizados: ${config.authorizedGroups.length}`);
        console.log(`🔗 Webhook URL: ${config.webhookUrl}`);
    });
}

// Manejo de errores
process.on('uncaughtException', (error) => {
    console.error('💥 Error no capturado:', error);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('💥 Promesa rechazada:', reason);
});

// Iniciar aplicación
init().catch(console.error);