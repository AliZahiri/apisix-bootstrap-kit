#!/bin/bash

set -e

echo "🔧 Preparing APISIX Bootstrap Environment..."

# Check docker
if ! command -v docker &> /dev/null; then
  echo "❌ Docker not found! Please install Docker first."
  exit 1
fi

# Check docker compose
if ! docker compose version &> /dev/null; then
  echo "❌ Docker Compose not found! Please install Docker Compose (v2+)."
  exit 1
fi

# Load credentials from .env file
if [ -f .env ]; then
  echo "🌱 Loading environment variables from .env"
  export $(grep -v '^#' .env | xargs)
else
  echo "❌ .env file not found!"
  exit 1
fi

ETCD_YML_PATH="/opt/apisix/etcd/etcd.conf.yml"
APISIX_YML_PATH="/opt/apisix/core/apisix_cnf.yml"
APISIX_DSH_YML_PATH="/opt/apisix/dashboard/apisix_dsh_cnf.yml"

# Create directory structure
echo "📁 Creating necessary directories in /opt/apisix..."
mkdir -p /opt/apisix/{core,etcd,dashboard,core/logs}
chmod -R 777 /opt/apisix/

# Generate config files from templates
echo "⚙️ Generating config files from templates..."

envsubst < ./config/etcd.conf.yml.tpl >  "$ETCD_YML_PATH"
envsubst < ./config/apisix_cnf.yml.tpl > "$APISIX_YML_PATH"
envsubst < ./config/apisix_dsh_cnf.yml.tpl > "$APISIX_DSH_YML_PATH"


echo "✅ All required directories and files created."


echo "🧨 Bringing down previous Docker Compose stack..."
docker compose down -v --volumes --remove-orphans


# Start Docker Compose
echo "🚀 Starting APISIX stack using Docker Compose..."
docker compose up -d


# Show access info
echo ""
echo "✅ Done! APISIX environment is ready."
echo ""
echo "🔐 APISIX Admin Key:     $APISIX_ADMIN_KEY"
echo "👤 APISIX Dashboard Login:"
echo "    🔸 Username: admin"
echo "    🔸 Password: $APISIX_ADMIN_KEY"
echo ""
echo "📍 Access Points:"
echo "    ➤ Gateway (HTTP):     http://localhost:80"
echo "    ➤ Admin API:          http://localhost:9180/apisix/admin/routes"
echo "    ➤ Dashboard UI:       http://localhost:9100"
echo ""
echo "🧪 Try it out:"
echo "    curl http://localhost/google"
