#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="Laravel App"
DEPLOY_PATH="/var/www/laravel"
BACKUP_PATH="/var/www/backups"
REPO_URL=""
BRANCH="main"

echo -e "${BLUE}🚀 Iniciando deploy de ${APP_NAME}...${NC}\n"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}❌ Este script deve ser executado como root${NC}"
    exit 1
fi

# Create backup
echo -e "${BLUE}📦 Criando backup...${NC}"
if [ -d "$DEPLOY_PATH" ]; then
    BACKUP_NAME="backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_PATH"
    cp -r "$DEPLOY_PATH" "$BACKUP_PATH/$BACKUP_NAME"
    echo -e "${GREEN}✅ Backup criado: $BACKUP_PATH/$BACKUP_NAME${NC}"
fi

# Clone/Update repository
echo -e "${BLUE}📥 Atualizando código...${NC}"
if [ -d "$DEPLOY_PATH" ]; then
    cd "$DEPLOY_PATH"
    git fetch origin
    git reset --hard origin/$BRANCH
else
    mkdir -p "$DEPLOY_PATH"
    cd "$DEPLOY_PATH"
    git clone -b $BRANCH $REPO_URL .
fi

# Install dependencies
echo -e "${BLUE}📦 Instalando dependências...${NC}"
composer install --no-dev --optimize-autoloader --no-interaction
npm ci --production

# Build assets
echo -e "${BLUE}🔨 Compilando assets...${NC}"
npm run build

# Set permissions
echo -e "${BLUE}🔐 Configurando permissões...${NC}"
chown -R www-data:www-data "$DEPLOY_PATH"
chmod -R 755 "$DEPLOY_PATH/storage"
chmod -R 755 "$DEPLOY_PATH/bootstrap/cache"

# Clear caches
echo -e "${BLUE}🧹 Limpando caches...${NC}"
cd "$DEPLOY_PATH"
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Run migrations
echo -e "${BLUE}🗄️  Executando migrações...${NC}"
php artisan migrate --force

# Restart services
echo -e "${BLUE}🔄 Reiniciando serviços...${NC}"
systemctl restart nginx
systemctl restart php8.4-fpm

echo -e "\n${GREEN}✅ Deploy concluído com sucesso!${NC}"
echo -e "${BLUE}🌐 Aplicação disponível em: http://localhost${NC}"
echo -e "${BLUE}📊 Logs em: $DEPLOY_PATH/storage/logs${NC}"
