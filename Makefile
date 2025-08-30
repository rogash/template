.PHONY: help install setup test quality stan psalm pint cs-fix cs-check sail-up sail-down sail-build sail-shell sail-test sail-artisan

help: ## Mostra esta ajuda
	@echo "Comandos disponíveis:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

install: ## Instala as dependências do projeto
	composer install
	npm install

setup: ## Configura o projeto para desenvolvimento
	cp env.example .env
	composer install
	php artisan key:generate
	php artisan migrate
	php artisan db:seed
	npm install
	npm run dev

test: ## Executa os testes
	php artisan test

test-coverage: ## Executa os testes com cobertura
	php artisan test --coverage

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
	phpstan analyse --memory-limit=2G

psalm: ## Executa análise estática com Psalm
	@echo "🔍 Executando Psalm..."
	psalm

pint: ## Formata o código com Laravel Pint
	@echo "🎨 Formatando código com Pint..."
	./vendor/bin/pint

cs-fix: ## Corrige problemas de estilo de código
	@echo "🔧 Corrigindo estilo de código..."
	./vendor/bin/phpcbf --standard=PSR12 app/

cs-check: ## Verifica estilo de código PSR-12
	@echo "🔍 Verificando estilo de código..."
	./vendor/bin/phpcs --standard=PSR12 app/

sail-up: ## Inicia os containers Docker
	./vendor/bin/sail up -d

sail-down: ## Para os containers Docker
	./vendor/bin/sail down

sail-build: ## Reconstrói os containers Docker
	./vendor/bin/sail build --no-cache

sail-shell: ## Acessa o shell do container Laravel
	./vendor/bin/sail shell

sail-test: ## Executa testes via Docker
	./vendor/bin/sail test

sail-artisan: ## Executa comandos Artisan via Docker
	./vendor/bin/sail artisan

fresh: ## Recria o banco de dados
	php artisan migrate:fresh --seed

cache-clear: ## Limpa todos os caches
	php artisan cache:clear
	php artisan config:clear
	php artisan route:clear
	php artisan view:clear

optimize: ## Otimiza a aplicação para produção
	php artisan config:cache
	php artisan route:cache
	php artisan view:cache

watch: ## Observa mudanças nos arquivos para desenvolvimento
	npm run dev

build: ## Compila assets para produção
	npm run build

laravel-12: ## Verifica se está usando Laravel 12
	@echo "🚀 Verificando versão do Laravel..."
	@php artisan --version
