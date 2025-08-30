#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Instalando Laravel 12...${NC}\n"

# Check if Laravel is already installed
if [ -f "artisan" ]; then
    echo -e "${GREEN}✅ Laravel já está instalado!${NC}"
    exit 0
fi

# Check if Composer is installed
if ! command -v composer &> /dev/null; then
    echo -e "${RED}❌ Composer não está instalado. Por favor, instale o Composer primeiro.${NC}"
    exit 1
fi

# Create new Laravel project in current directory
echo -e "${BLUE}📦 Criando projeto Laravel 12...${NC}"
composer create-project laravel/laravel:^12.0 . --prefer-dist --no-interaction

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Laravel 12 instalado com sucesso!${NC}"

    # Copy our custom files back
    echo -e "${BLUE}📋 Restaurando arquivos customizados...${NC}"

    # Restore .env.example if it exists
    if [ -f "env.example" ]; then
        cp env.example .env.example
        echo -e "${GREEN}✅ .env.example restaurado${NC}"
    fi

    # Restore custom configurations
    if [ -f "phpstan.neon" ]; then
        echo -e "${GREEN}✅ Configurações PHPStan mantidas${NC}"
    fi

    if [ -f "psalm.xml" ]; then
        echo -e "${GREEN}✅ Configurações Psalm mantidas${NC}"
    fi

    if [ -f "pint.json" ]; then
        echo -e "${GREEN}✅ Configurações Laravel Pint mantidas${NC}"
    fi

    if [ -f "Makefile" ]; then
        echo -e "${GREEN}✅ Makefile mantido${NC}"
    fi

    echo -e "\n${GREEN}🎉 Laravel 12 instalado e configurado!${NC}"
    echo -e "${BLUE}🚀 Próximos passos:${NC}"
    echo -e "1. Execute: ${GREEN}composer install${NC}"
    echo -e "2. Execute: ${GREEN}php artisan key:generate${NC}"
    echo -e "3. Execute: ${GREEN}php artisan serve${NC}"

else
    echo -e "${RED}❌ Erro ao instalar Laravel 12${NC}"
    exit 1
fi
