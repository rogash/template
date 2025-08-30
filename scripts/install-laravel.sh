#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Instalando Laravel 12 no diretório atual...${NC}\n"

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

# Check if directory is empty (except template files)
TEMPLATE_FILES=(".git" "README.md" "LICENSE" "composer.json" "package.json" "Makefile" "scripts" "docs" "docker" ".cursorrules" "phpstan.neon" "pint.json" "phpcs.xml" ".eslintrc.js" ".prettierrc" "tsconfig.json" "vite.config.js" "tailwind.config.js" "postcss.config.js" ".editorconfig" ".github" "CHANGELOG.md" "env.example" "docker-compose.yml" "docker-compose.prod.yml")

# Count non-template files
NON_TEMPLATE_COUNT=0
for item in *; do
    if [ -e "$item" ]; then
        IS_TEMPLATE=false
        for template_file in "${TEMPLATE_FILES[@]}"; do
            if [ "$item" = "$template_file" ]; then
                IS_TEMPLATE=true
                break
            fi
        done

        if [ "$IS_TEMPLATE" = false ]; then
            NON_TEMPLATE_COUNT=$((NON_TEMPLATE_COUNT + 1))
        fi
    fi
done

if [ $NON_TEMPLATE_COUNT -gt 0 ]; then
    echo -e "${YELLOW}⚠️  Diretório não está vazio.${NC}"
    echo -e "${BLUE}📋 Arquivos não-template encontrados: $NON_TEMPLATE_COUNT${NC}"

    read -p "Deseja continuar e instalar Laravel aqui mesmo? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}❌ Instalação cancelada.${NC}"
        echo -e "${BLUE}💡 Dica: Clone este template em uma pasta vazia para usar como base.${NC}"
        exit 1
    fi
fi

# Backup template files
echo -e "${BLUE}📦 Fazendo backup dos arquivos do template...${NC}"
TEMP_DIR=$(mktemp -d)
cp -r . "$TEMP_DIR/template_backup" 2>/dev/null || true

# Create new Laravel project in current directory
echo -e "${BLUE}📦 Criando projeto Laravel 12...${NC}"
composer create-project laravel/laravel:^12.0 . --prefer-dist --no-interaction

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Laravel 12 instalado com sucesso!${NC}"

    # Restore template files
    echo -e "${BLUE}📋 Restaurando arquivos do template...${NC}"

    # Restore custom configurations
    if [ -d "$TEMP_DIR/template_backup" ]; then
        # Restore specific template files
        cp "$TEMP_DIR/template_backup/composer.json" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/package.json" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/Makefile" . 2>/dev/null || true
        # Copy Laravel-specific PHPStan config
        cp "$TEMP_DIR/template_backup/phpstan.laravel.neon" ./phpstan.neon 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/pint.json" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/phpcs.xml" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/.eslintrc.js" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/.prettierrc" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/tsconfig.json" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/vite.config.js" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/tailwind.config.js" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/postcss.config.js" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/.editorconfig" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/.cursorrules" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/CHANGELOG.md" . 2>/dev/null || true

        # Restore directories
        cp -r "$TEMP_DIR/template_backup/scripts" . 2>/dev/null || true
        cp -r "$TEMP_DIR/template_backup/docs" . 2>/dev/null || true
        cp -r "$TEMP_DIR/template_backup/docker" . 2>/dev/null || true
        cp -r "$TEMP_DIR/template_backup/.github" . 2>/dev/null || true

        # Restore environment example
        if [ -f "$TEMP_DIR/template_backup/env.example" ]; then
            cp "$TEMP_DIR/template_backup/env.example" .env.example
        fi

        # Restore Docker files
        cp "$TEMP_DIR/template_backup/docker-compose.yml" . 2>/dev/null || true
        cp "$TEMP_DIR/template_backup/docker-compose.prod.yml" . 2>/dev/null || true

        echo -e "${GREEN}✅ Arquivos do template restaurados${NC}"
    fi

    # Clean up
    rm -rf "$TEMP_DIR"

    echo -e "\n${GREEN}🎉 Laravel 12 instalado e configurado com o template!${NC}"
    echo -e "${BLUE}🚀 Próximos passos:${NC}"
    echo -e "1. Execute: ${GREEN}composer install${NC}"
    echo -e "2. Execute: ${GREEN}php artisan key:generate${NC}"
    echo -e "3. Execute: ${GREEN}php artisan serve${NC}"

else
    echo -e "${RED}❌ Erro ao instalar Laravel 12${NC}"
    # Restore original files
    if [ -d "$TEMP_DIR/template_backup" ]; then
        cp -r "$TEMP_DIR/template_backup"/* . 2>/dev/null || true
        echo -e "${YELLOW}⚠️  Arquivos originais restaurados${NC}"
    fi
    rm -rf "$TEMP_DIR"
    exit 1
fi
