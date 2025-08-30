.PHONY: help install setup test quality stan psalm pint cs-fix cs-check sail-up sail-down sail-build sail-shell sail-test sail-artisan create-project

help: ## Mostra esta ajuda
	@echo "🚀 Template Laravel - Comandos Disponíveis"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "📚 Para mais informações, consulte o README.md"

install: ## Instala dependências PHP
	@echo "📦 Instalando dependências PHP..."
	composer install
	@echo "✅ Dependências instaladas!"

setup: ## Configuração inicial do projeto
	@echo "🚀 Configurando projeto..."
	./scripts/setup.sh

create-project: ## Cria um novo projeto Laravel a partir do template (escolha a localização)
	@echo "🚀 Criando novo projeto..."
	./scripts/create-project.sh

test: ## Executa testes (apenas quando Laravel estiver instalado)
	@echo "🧪 Executando testes..."
	@if [ -f "artisan" ]; then php artisan test; else echo "⚠️ Laravel não instalado. Execute ./scripts/create-project.sh primeiro."; fi

quality: ## Executa todas as verificações de qualidade
	@echo "🔍 Executando verificações de qualidade..."
	@make stan
	@make psalm
	@make cs-check
	@echo "✅ Todas as verificações concluídas!"

stan: ## Executa análise estática com PHPStan
	@echo "🔍 Executando PHPStan..."
	./vendor/bin/phpstan analyse --memory-limit=2G

psalm: ## Executa análise estática com Psalm
	@echo "🔍 Executando Psalm..."
	./vendor/bin/psalm --no-progress

pint: ## Formata o código com Laravel Pint (apenas quando Laravel estiver instalado)
	@echo "🎨 Formatando código com Pint..."
	@if [ -f "artisan" ]; then ./vendor/bin/pint; else echo "⚠️ Laravel não instalado. Execute ./scripts/create-project.sh primeiro."; fi

cs-check: ## Verifica estilo de código com PHP_CodeSniffer
	@echo "🔍 Verificando estilo de código..."
	./vendor/bin/php-cs-fixer fix --dry-run --diff --config=.php-cs-fixer.php
	./vendor/bin/phpcs --standard=PSR12 scripts/ docs/ docker/ .github/ || true

cs-fix: ## Corrige estilo de código automaticamente
	@echo "🔧 Corrigindo estilo de código..."
	./vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.php
	./vendor/bin/phpcbf --standard=PSR12 scripts/ docs/ docker/ .github/ || true

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

# Comandos de frontend removidos - este template foca em qualidade de código PHP

cache-clear: ## Limpa todos os caches (apenas quando Laravel estiver instalado)
	@echo "🧹 Limpando caches..."
	@if [ -f "artisan" ]; then php artisan cache:clear config:clear route:clear view:clear; echo "✅ Caches limpos!"; else echo "⚠️ Laravel não instalado. Execute ./scripts/create-project.sh primeiro."; fi

optimize: ## Otimiza para produção (apenas quando Laravel estiver instalado)
	@echo "⚡ Otimizando para produção..."
	@if [ -f "artisan" ]; then php artisan config:cache route:cache view:cache; echo "✅ Otimização concluída!"; else echo "⚠️ Laravel não instalado. Execute ./scripts/create-project.sh primeiro."; fi

fresh: ## Recria banco de dados (apenas quando Laravel estiver instalado)
	@echo "🔄 Recriando banco de dados..."
	@if [ -f "artisan" ]; then php artisan migrate:fresh --seed; else echo "⚠️ Laravel não instalado. Execute ./scripts/create-project.sh primeiro."; fi

laravel-12: ## Verifica versão do Laravel (apenas quando Laravel estiver instalado)
	@echo "🔍 Verificando versão do Laravel..."
	@if [ -f "artisan" ]; then php artisan --version; else echo "⚠️ Laravel não instalado. Execute ./scripts/create-project.sh primeiro."; fi
