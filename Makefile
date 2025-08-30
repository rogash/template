.PHONY: help install setup test quality stan psalm pint cs-fix cs-check sail-up sail-down sail-build sail-shell sail-test sail-artisan create-project

help: ## Mostra esta ajuda
	@echo "🚀 Template Laravel - Comandos Disponíveis"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "📚 Para mais informações, consulte o README.md"

install: ## Instala dependências PHP e Node.js
	@echo "📦 Instalando dependências PHP..."
	composer install
	@echo "📦 Instalando dependências Node.js..."
	npm install
	@echo "✅ Dependências instaladas!"

setup: ## Configuração inicial do projeto
	@echo "🚀 Configurando projeto..."
	./scripts/setup.sh

create-project: ## Cria um novo projeto Laravel a partir do template
	@echo "🚀 Criando novo projeto..."
	./scripts/create-project.sh

test: ## Executa testes
	@echo "🧪 Executando testes..."
	php artisan test

quality: ## Executa todas as verificações de qualidade
	@echo "🔍 Executando verificações de qualidade..."
	@make stan
	@make psalm
	@make pint
	@make cs-check
	@make test
	@echo "✅ Todas as verificações concluídas!"

stan: ## Executa análise estática com PHPStan
	@echo "🔍 Executando PHPStan..."
	./vendor/bin/phpstan analyse --memory-limit=2G

psalm: ## Executa análise estática com Psalm
	@echo "🔍 Executando Psalm..."
	./vendor/bin/psalm --no-progress

pint: ## Formata o código with Laravel Pint
	@echo "🎨 Formatando código com Pint..."
	./vendor/bin/pint

cs-check: ## Verifica estilo de código com PHP_CodeSniffer
	@echo "🔍 Verificando estilo de código..."
	./vendor/bin/phpcs --standard=PSR12 app/ config/ database/ routes/ tests/

cs-fix: ## Corrige estilo de código automaticamente
	@echo "🔧 Corrigindo estilo de código..."
	./vendor/bin/phpcbf --standard=PSR12 app/ config/ database/ routes/ tests/

sail-up: ## Inicia serviços Docker
	@echo "🐳 Iniciando serviços Docker..."
	./vendor/bin/sail up -d

sail-down: ## Para serviços Docker
	@echo "🐳 Parando serviços Docker..."
	./vendor/bin/sail down

sail-build: ## Reconstrói containers Docker
	@echo "🐳 Reconstruindo containers..."
	./vendor/bin/sail build --no-cache

sail-shell: ## Acessa shell do container
	@echo "🐳 Acessando shell do container..."
	./vendor/bin/sail shell

sail-test: ## Executa testes via Docker
	@echo "🧪 Executando testes via Docker..."
	./vendor/bin/sail test

sail-artisan: ## Executa comando Artisan via Docker
	@echo "🔧 Executando comando Artisan..."
	./vendor/bin/sail artisan $(command)

watch: ## Inicia Vite em modo watch
	@echo "👀 Iniciando Vite em modo watch..."
	npm run dev

build: ## Compila assets para produção
	@echo "🏗️ Compilando assets..."
	npm run build

cache-clear: ## Limpa todos os caches
	@echo "🧹 Limpando caches..."
	php artisan cache:clear
	php artisan config:clear
	php artisan route:clear
	php artisan view:clear
	@echo "✅ Caches limpos!"

optimize: ## Otimiza para produção
	@echo "⚡ Otimizando para produção..."
	php artisan config:cache
	php artisan route:cache
	php artisan view:cache
	@echo "✅ Otimização concluída!"

fresh: ## Recria banco de dados
	@echo "🔄 Recriando banco de dados..."
	php artisan migrate:fresh --seed

laravel-12: ## Verifica versão do Laravel
	@echo "🔍 Verificando versão do Laravel..."
	php artisan --version
