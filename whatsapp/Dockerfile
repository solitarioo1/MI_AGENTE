# WhatsApp Bot Dockerfile
FROM node:18-alpine

# Instalar dependencias del sistema
RUN apk add --no-cache \
    curl \
    git \
    python3 \
    make \
    g++ \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    giflib-dev

# Crear directorio de la aplicación
WORKDIR /app

# Copiar package files
COPY package*.json ./

# Instalar dependencias de Node.js
RUN npm install --only=production && npm cache clean --force

# Copiar código fuente
COPY . .

# Crear directorio para sesiones
RUN mkdir -p /app/sessions && chown node:node /app/sessions

# Cambiar a usuario no-root
USER node

# Exponer puerto
EXPOSE 3000

# Health check endpoint
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:3000/health || exit 1

# Comando de inicio
CMD ["node", "server.js"]