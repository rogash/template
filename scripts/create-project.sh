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

# Get project name and location
read -p "Digite o nome do novo projeto: " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}❌ Nome do projeto não pode ser vazio${NC}"
    exit 1
fi

# Get project location
echo -e "${BLUE}📍 Onde você quer criar o projeto?${NC}"
echo -e "${YELLOW}1.${NC} Na pasta atual (dentro do template)"
echo -e "${YELLOW}2.${NC} Em uma pasta específica (recomendado)"
echo -e "${YELLOW}3.${NC} Em uma pasta pai (../)"
read -p "Escolha uma opção (1-3): " LOCATION_CHOICE

case $LOCATION_CHOICE in
    1)
        PROJECT_PATH="$PROJECT_NAME"
        echo -e "${BLUE}📁 Projeto será criado em: ${GREEN}$(pwd)/$PROJECT_NAME${NC}"
        ;;
    2)
        read -p "Digite o caminho completo (ex: /caminho/para/projetos): " CUSTOM_PATH
        if [ -z "$CUSTOM_PATH" ]; then
            echo -e "${RED}❌ Caminho não pode ser vazio${NC}"
            exit 1
        fi
        PROJECT_PATH="$CUSTOM_PATH/$PROJECT_NAME"
        echo -e "${BLUE}📁 Projeto será criado em: ${GREEN}$PROJECT_PATH${NC}"
        ;;
    3)
        PROJECT_PATH="../$PROJECT_NAME"
        echo -e "${BLUE}📁 Projeto será criado em: ${GREEN}$(realpath $PROJECT_PATH)${NC}"
        ;;
    *)
        echo -e "${RED}❌ Opção inválida${NC}"
        exit 1
        ;;
esac

# Check if project directory already exists
if [ -d "$PROJECT_PATH" ]; then
    echo -e "${YELLOW}⚠️  O diretório '$PROJECT_PATH' já existe.${NC}"
    read -p "Deseja sobrescrever? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}❌ Criação cancelada.${NC}"
        exit 1
    fi
    rm -rf "$PROJECT_PATH"
fi

# Create project directory
echo -e "${BLUE}📁 Criando diretório do projeto...${NC}"
mkdir -p "$PROJECT_PATH"
cd "$PROJECT_PATH"

# Create new Laravel project
echo -e "${BLUE}📦 Criando projeto Laravel 12...${NC}"
composer create-project laravel/laravel:^12.0 . --prefer-dist --no-interaction

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Laravel 12 criado com sucesso!${NC}"

        # Copy template files from template directory
    echo -e "${BLUE}📋 Copiando arquivos do template...${NC}"

    # Find template directory (could be in different locations)
    TEMPLATE_DIR=""
    if [ -d "../../template" ]; then
        TEMPLATE_DIR="../../template"
    elif [ -d "../template" ]; then
        TEMPLATE_DIR="../template"
    elif [ -d "template" ]; then
        TEMPLATE_DIR="template"
    else
        # Try to find template by looking for characteristic files
        TEMPLATE_DIR="$(find .. -maxdepth 3 -name "phpstan.neon" -o -name ".cursorrules" | head -1 | xargs dirname 2>/dev/null || echo "")"
    fi

    if [ -n "$TEMPLATE_DIR" ] && [ -d "$TEMPLATE_DIR" ]; then
        echo -e "${GREEN}✅ Template encontrado em: $TEMPLATE_DIR${NC}"

        # Copy template files (excluding .git for clean repository)
        cp "$TEMPLATE_DIR/README.md" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/Makefile" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/pint.json" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/phpcs.xml" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/.eslintrc.js" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/.prettierrc" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/tsconfig.json" . 2>/dev/null || true
        # Vite config será criado especificamente para Laravel
        cp "$TEMPLATE_DIR/tailwind.config.js" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/postcss.config.js" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/.editorconfig" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/.cursorrules" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/CHANGELOG.md" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/env.example" .env.example 2>/dev/null || true
        cp "$TEMPLATE_DIR/docker-compose.yml" . 2>/dev/null || true
        cp "$TEMPLATE_DIR/docker-compose.prod.yml" . 2>/dev/null || true

        # Copy directories
        cp -r "$TEMPLATE_DIR/scripts" . 2>/dev/null || true
        cp -r "$TEMPLATE_DIR/docs" . 2>/dev/null || true
        cp -r "$TEMPLATE_DIR/docker" . 2>/dev/null || true
        cp -r "$TEMPLATE_DIR/.github" . 2>/dev/null || true

        echo -e "${GREEN}✅ Arquivos do template copiados${NC}"
    else
        echo -e "${YELLOW}⚠️  Não foi possível detectar o diretório do template${NC}"
    fi

    # Install template dependencies
    echo -e "${BLUE}📦 Instalando dependências do template...${NC}"
    composer require --dev phpstan/phpstan larastan/larastan vimeo/psalm psalm/plugin-laravel friendsofphp/php-cs-fixer squizlabs/php_codesniffer phpcompatibility/php-compatibility laravel/dusk nunomaduro/collision --no-interaction

    # Install dependencies
    echo -e "${BLUE}📦 Instalando dependências...${NC}"
    composer install --no-interaction
    npm install

    # Create Laravel-specific configurations
    echo -e "${BLUE}⚙️  Criando configurações para Laravel...${NC}"

    # Create phpstan.neon for Laravel
    cat > phpstan.neon << 'EOF'
includes:
    - vendor/larastan/larastan/extension.neon

parameters:
    level: 8
    paths:
        - app
        - config
        - database
        - routes
        - tests
    excludePaths:
        - vendor
        - node_modules
        - storage
        - bootstrap/cache
        - tests/coverage
    ignoreErrors:
        - '#Call to an undefined method Illuminate\\Database\\Eloquent\\Builder::#'
        - '#Call to an undefined method Illuminate\\Database\\Eloquent\\Model::#'
        - '#Call to an undefined method Illuminate\\Database\\Eloquent\\Collection::#'
        - '#Call to an undefined method Illuminate\\Support\\Collection::#'
        - '#Call to an undefined method Illuminate\\Http\\Request::#'
        - '#Call to an undefined method Illuminate\\Http\\Response::#'
EOF

    # Create psalm.xml for Laravel
    cat > psalm.xml << 'EOF'
<?xml version="1.0"?>
<psalm
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="https://getpsalm.org/schema/config"
    xsi:schemaLocation="https://getpsalm.org/schema/config vendor/vimeo/psalm/config.xsd"
    errorLevel="4"
    resolveFromConfigFile="true"
    findUnusedCode="false"
    cacheDirectory=".psalm-cache"
>
    <projectFiles>
        <directory name="app" />
        <directory name="config" />
        <directory name="database" />
        <directory name="routes" />
        <directory name="tests" />
    </projectFiles>

    <ignoreFiles>
        <directory name="vendor" />
        <directory name="node_modules" />
        <directory name="storage" />
        <directory name="bootstrap/cache" />
        <directory name="tests/coverage" />
    </ignoreFiles>

    <plugins>
        <pluginClass class="Psalm\LaravelPlugin\Plugin" />
    </plugins>

    <issueHandlers>
        <LessSpecificReturnType errorLevel="info" />
        <MoreSpecificReturnType errorLevel="info" />
        <MissingReturnType errorLevel="info" />
        <MissingPropertyType errorLevel="info" />
        <InvalidDocblock errorLevel="info" />
        <MissingDependency errorLevel="info" />
        <DeprecatedMethod errorLevel="info" />
        <UndefinedGlobalVariable errorLevel="suppress" />
        <MixedAssignment errorLevel="info" />
        <MixedArgument errorLevel="info" />
        <MixedArrayAccess errorLevel="info" />
        <MixedMethodCall errorLevel="info" />
        <MixedPropertyFetch errorLevel="info" />
        <MixedReturnStatement errorLevel="info" />
        <UndefinedMethod errorLevel="info" />
        <UndefinedPropertyFetch errorLevel="info" />
    </issueHandlers>
</psalm>
EOF

    # Create PHP CS Fixer config
    cat > .php-cs-fixer.php << 'EOF'
<?php

$finder = PhpCsFixer\Finder::create()
    ->in([
        __DIR__ . '/app',
        __DIR__ . '/config',
        __DIR__ . '/database',
        __DIR__ . '/routes',
        __DIR__ . '/tests',
    ])
    ->exclude([
        'vendor',
        'node_modules',
        'storage',
        'bootstrap/cache',
    ]);

return (new PhpCsFixer\Config())
    ->setRules([
        '@PSR12' => true,
        'array_syntax' => ['syntax' => 'short'],
        'ordered_imports' => ['sort_algorithm' => 'alpha'],
        'no_unused_imports' => true,
        'not_operator_with_successor_space' => true,
        'trailing_comma_in_multiline' => true,
        'phpdoc_scalar' => true,
        'unary_operator_spaces' => true,
        'binary_operator_spaces' => true,
        'blank_line_before_statement' => [
            'statements' => ['break', 'continue', 'declare', 'return', 'throw', 'try'],
        ],
        'phpdoc_single_line_var_spacing' => true,
        'phpdoc_var_without_name' => true,
        'method_argument_space' => [
            'on_multiline' => 'ensure_fully_multiline',
            'keep_multiple_spaces_after_comma' => true,
        ],
        'single_trait_insert_per_statement' => true,
    ])
    ->setFinder($finder);
EOF

    # Create Vite config for Laravel
    cat > vite.config.js << 'EOF'
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
            },
        }),
    ],
    resolve: {
        alias: {
            '@': '/resources/js',
            '~': '/resources',
        },
    },
    server: {
        hmr: {
            host: 'localhost',
        },
    },
});
EOF

    echo -e "${GREEN}✅ Configurações para Laravel criadas${NC}"

    # Generate application key
    echo -e "${BLUE}🔑 Gerando chave da aplicação...${NC}"
    php artisan key:generate --no-interaction

    # Set permissions
    echo -e "${BLUE}🔐 Configurando permissões...${NC}"
    chmod -R 755 storage bootstrap/cache

    # Initialize new Git repository
    echo -e "${BLUE}📝 Inicializando novo repositório Git...${NC}"
    git init
    git add .
    git commit -m "feat: projeto Laravel inicial criado a partir do template

- Laravel 12 instalado e configurado
- Ferramentas de qualidade configuradas
- Estrutura de projeto organizada
- Configurações Docker e CI/CD incluídas"

    echo -e "${GREEN}✅ Repositório Git inicializado com commit inicial${NC}"

    echo -e "\n${GREEN}🎉 Projeto '$PROJECT_NAME' criado com sucesso!${NC}"
    echo -e "${BLUE}📍 Localização: ${GREEN}$(pwd)${NC}"
    echo -e "${BLUE}🚀 Próximos passos:${NC}"
    echo -e "1. Entre no diretório: ${GREEN}cd $PROJECT_PATH${NC}"
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
