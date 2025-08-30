#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Iniciando setup do projeto Laravel...${NC}\n"

# Check if PHP is installed
if ! command -v php &> /dev/null; then
    echo -e "${RED}❌ PHP não está instalado. Por favor, instale o PHP 8.4+${NC}"
    exit 1
fi

# Check PHP version
PHP_VERSION=$(php -r "echo PHP_VERSION;")
echo -e "${BLUE}📋 Versão do PHP: ${PHP_VERSION}${NC}"

if [[ $(echo "$PHP_VERSION 8.4" | tr " " "\n" | sort -V | head -n 1) != "8.4" ]]; then
    echo -e "${RED}❌ PHP 8.4+ é necessário. Versão atual: ${PHP_VERSION}${NC}"
    exit 1
fi

# Check if Composer is installed
if ! command -v composer &> /dev/null; then
    echo -e "${RED}❌ Composer não está instalado. Por favor, instale o Composer${NC}"
    exit 1
fi

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js não está instalado. Por favor, instale o Node.js 18+${NC}"
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v)
echo -e "${BLUE}📋 Versão do Node.js: ${NODE_VERSION}${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠️  Docker não está instalado. Laravel Sail não estará disponível${NC}"
    DOCKER_AVAILABLE=false
else
    echo -e "${BLUE}📋 Docker está disponível${NC}"
    DOCKER_AVAILABLE=true
fi

# Check if Laravel is installed
if [ ! -f "artisan" ]; then
    echo -e "${YELLOW}⚠️  Laravel não está instalado. Instalando Laravel 12...${NC}"

    # Run Laravel installation script
    if [ -f "scripts/install-laravel.sh" ]; then
        chmod +x scripts/install-laravel.sh
        ./scripts/install-laravel.sh

        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Erro ao instalar Laravel. Abortando setup.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Script de instalação do Laravel não encontrado.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ Laravel já está instalado${NC}"
fi

echo -e "\n${BLUE}📦 Instalando dependências do Composer...${NC}"
composer install --no-interaction --prefer-dist

echo -e "\n${BLUE}📦 Instalando dependências do NPM...${NC}"
npm install

echo -e "\n${BLUE}🔧 Configurando ambiente...${NC}"

# Copy environment file if it doesn't exist
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        cp .env.example .env
        echo -e "${GREEN}✅ Arquivo .env criado a partir de .env.example${NC}"
    else
        echo -e "${YELLOW}⚠️  Arquivo .env.example não encontrado${NC}"
    fi
fi

# Generate application key
if [ -f .env ]; then
    php artisan key:generate --no-interaction
    echo -e "${GREEN}✅ Chave da aplicação gerada${NC}"
fi

# Set proper permissions
if [ -d "storage" ] && [ -d "bootstrap/cache" ]; then
    chmod -R 755 storage bootstrap/cache
    echo -e "${GREEN}✅ Permissões configuradas${NC}"
else
    echo -e "${YELLOW}⚠️  Diretórios storage ou bootstrap/cache não encontrados${NC}"
fi

echo -e "\n${BLUE}🔍 Verificando qualidade do código...${NC}"

# Run PHPStan
if [ -f "vendor/bin/phpstan" ]; then
    echo -e "${BLUE}📋 Executando PHPStan...${NC}"
    ./vendor/bin/phpstan analyse --memory-limit=2G --no-progress || echo -e "${YELLOW}⚠️  PHPStan encontrou alguns problemas${NC}"
else
    echo -e "${YELLOW}⚠️  PHPStan não está disponível${NC}"
fi

# Run Laravel Pint
if [ -f "vendor/bin/pint" ]; then
    echo -e "${BLUE}📋 Executando Laravel Pint...${NC}"
    ./vendor/bin/pint --test || echo -e "${YELLOW}⚠️  Laravel Pint encontrou alguns problemas${NC}"
else
    echo -e "${YELLOW}⚠️  Laravel Pint não está disponível${NC}"
fi

echo -e "\n${GREEN}✅ Setup concluído com sucesso!${NC}\n"

echo -e "${BLUE}🚀 Próximos passos:${NC}"
echo -e "1. Configure seu arquivo .env com as credenciais do banco de dados"
echo -e "2. Execute as migrações: ${GREEN}php artisan migrate${NC}"
echo -e "3. Execute os seeders: ${GREEN}php artisan db:seed${NC}"
echo -e "4. Inicie o servidor: ${GREEN}php artisan serve${NC}"

if [ "$DOCKER_AVAILABLE" = true ]; then
    echo -e "\n${BLUE}🐳 Para usar Laravel Sail:${NC}"
    echo -e "1. Inicie os containers: ${GREEN}./vendor/bin/sail up -d${NC}"
    echo -e "2. Acesse: ${GREEN}http://localhost${NC}"
fi

echo -e "\n${BLUE}📚 Comandos úteis:${NC}"
echo -e "- Ver todos os comandos: ${GREEN}make help${NC}"
echo -e "- Verificação de qualidade: ${GREEN}make quality${NC}"
echo -e "- Executar testes: ${GREEN}make test${NC}"

echo -e "\n${GREEN}🎉 Boa programação com Laravel!${NC}"
