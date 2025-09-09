#!/bin/bash

# Generador de certificados SSL auto-firmados para desarrollo
# Ejecutar desde el directorio raíz del proyecto

echo "🔐 Generando certificados SSL auto-firmados..."

# Crear directorio SSL si no existe
mkdir -p ssl

# Generar clave privada
openssl genrsa -out ssl/key.pem 2048

# Generar certificado auto-firmado válido por 365 días
openssl req -new -x509 -key ssl/key.pem -out ssl/cert.pem -days 365 -subj "/C=MX/ST=Estado/L=Ciudad/O=AgentePersonal/OU=IT/CN=172.206.16.218"

# Configurar permisos
chmod 600 ssl/key.pem
chmod 644 ssl/cert.pem

echo "✅ Certificados SSL generados:"
echo "   - Certificado: ssl/cert.pem"
echo "   - Clave privada: ssl/key.pem"
echo "   - Válido por: 365 días"
echo ""
echo "⚠️  NOTA: Son certificados auto-firmados (para desarrollo)"
echo "   Para producción, usa Let's Encrypt con Certbot"
echo ""
echo "🚀 Ya puedes usar HTTPS en: https://172.206.16.218:8443"
