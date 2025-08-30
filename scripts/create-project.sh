#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Criador de Projetos Laravel a partir do Template${NC}\n"

# Check if Composer is installed
if ! command -v composer &> /dev/null; then
    echo -e "${RED}❌ Composer não está instalado. Por favor, instale o Composer primeiro.${NC}"
    exit 1
fi

# Get project name
read -p "Digite o nome do novo projeto: " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}❌ Nome do projeto não pode ser vazio${NC}"
    exit 1
fi

# Check if project directory already exists
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${YELLOW}⚠️  O diretório '$PROJECT_NAME' já existe.${NC}"
    read -p "Deseja sobrescrever? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}❌ Criação cancelada.${NC}"
        exit 1
    fi
    rm -rf "$PROJECT_NAME"
fi

# Create project directory
echo -e "${BLUE}📁 Criando diretório do projeto...${NC}"
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# Create new Laravel project
echo -e "${BLUE}📦 Criando projeto Laravel 12...${NC}"
composer create-project laravel/laravel:^12.0 . --prefer-dist --no-interaction

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Laravel 12 criado com sucesso!${NC}"

    # Copy template files from parent directory
    echo -e "${BLUE}📋 Copiando arquivos do template...${NC}"

    PARENT_DIR="$(dirname "$(pwd)")"
    TEMPLATE_DIR="$(basename "$PARENT_DIR")"

    if [ "$TEMPLATE_DIR" = "template" ]; then
        # We're in the template directory, copy from current location
        cp -r ../.git . 2>/dev/null || true
        cp ../README.md . 2>/dev/null || true
        cp ../Makefile . 2>/dev/null || true
        cp ../phpstan.neon . 2>/dev/null || true
        cp ../pint.json . 2>/dev/null || true
        cp ../phpcs.xml . 2>/dev/null || true
        cp ../.eslintrc.js . 2>/dev/null || true
        cp ../.prettierrc . 2>/dev/null || true
        cp ../tsconfig.json . 2>/dev/null || true
        cp ../vite.config.js . 2>/dev/null || true
        cp ../tailwind.config.js . 2>/dev/null || true
        cp ../postcss.config.js . 2>/dev/null || true
        cp ../.editorconfig . 2>/dev/null || true
        cp ../.cursorrules . 2>/dev/null || true
        cp ../CHANGELOG.md . 2>/dev/null || true
        cp ../env.example .env.example 2>/dev/null || true
        cp ../docker-compose.yml . 2>/dev/null || true
        cp ../docker-compose.prod.yml . 2>/dev/null || true

        # Copy directories
        cp -r ../scripts . 2>/dev/null || true
        cp -r ../docs . 2>/dev/null || true
        cp -r ../docker . 2>/dev/null || true
        cp -r ../.github . 2>/dev/null || true

        echo -e "${GREEN}✅ Arquivos do template copiados${NC}"
    else
        echo -e "${YELLOW}⚠️  Não foi possível detectar o diretório do template${NC}"
    fi

    # Update composer.json with template dependencies
    echo -e "${BLUE}📦 Atualizando dependências do template...${NC}"
    composer require --dev phpstan/phpstan nunomaduro/larastan friendsofphp/php-cs-fixer squizlabs/php_codesniffer phpcompatibility/php-compatibility --no-interaction

    # Install dependencies
    echo -e "${BLUE}📦 Instalando dependências...${NC}"
    composer install --no-interaction
    npm install

    # Generate application key
    echo -e "${BLUE}🔑 Gerando chave da aplicação...${NC}"
    php artisan key:generate --no-interaction

    # Set permissions
    echo -e "${BLUE}🔐 Configurando permissões...${NC}"
    chmod -R 755 storage bootstrap/cache

    echo -e "\n${GREEN}🎉 Projeto '$PROJECT_NAME' criado com sucesso!${NC}"
    echo -e "${BLUE}🚀 Próximos passos:${NC}"
    echo -e "1. Entre no diretório: ${GREEN}cd $PROJECT_NAME${NC}"
    echo -e "2. Configure o ambiente: ${GREEN}cp .env.example .env${NC}"
    echo -e "3. Configure o banco de dados no arquivo .env"
    echo -e "4. Execute as migrações: ${GREEN}php artisan migrate${NC}"
    echo -e "5. Inicie o servidor: ${GREEN}php artisan serve${NC}"

    echo -e "\n${BLUE}📚 Comandos úteis:${NC}"
    echo -e "- Ver todos os comandos: ${GREEN}make help${NC}"
    echo -e "- Verificação de qualidade: ${GREEN}make quality${NC}"
    echo -e "- Executar testes: ${GREEN}make test${NC}"

    echo -e "\n${GREEN}🎉 Boa programação com Laravel!${NC}"

else
    echo -e "${RED}❌ Erro ao criar projeto Laravel${NC}"
    exit 1
fi
