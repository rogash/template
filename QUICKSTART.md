# 🚀 Quick Start - Template Laravel

## ⚡ Início Rápido

### 1. Clone e Setup
```bash
git clone <seu-repositorio>
cd <nome-do-projeto>
./scripts/setup.sh
```

### 2. Configure o Ambiente
```bash
# Copie o arquivo de ambiente
cp .env.example .env

# Edite o .env com suas configurações
nano .env

# Gere a chave da aplicação
php artisan key:generate
```

### 3. Banco de Dados
```bash
# Execute as migrações
php artisan migrate

# Popule com dados de teste
php artisan db:seed
```

### 4. Inicie o Servidor
```bash
# Desenvolvimento local
php artisan serve

# Ou com Docker (recomendado)
./vendor/bin/sail up -d
```

## 🎯 Comandos Essenciais

### Desenvolvimento
```bash
# Ver todos os comandos disponíveis
make help

# Verificação de qualidade completa
make quality

# Formatar código
make pint

# Executar testes
make test
```

### Docker (Laravel Sail)
```bash
# Iniciar serviços
make sail-up

# Parar serviços
make sail-down

# Shell do container
make sail-shell

# Comandos Artisan via Docker
./vendor/bin/sail artisan migrate
./vendor/bin/sail test
```

### Qualidade de Código
```bash
# Análise estática
make stan          # PHPStan

# Formatação
make pint          # Laravel Pint
make cs-check      # Verificar PSR-12
make cs-fix        # Corrigir PSR-12
```

## 🌐 Acessos

- **Aplicação**: http://localhost
- **MySQL**: localhost:3306
- **Redis**: localhost:6379
- **Meilisearch**: http://localhost:7700
- **Mailpit**: http://localhost:8025

## 📚 Documentação Completa

- [Guia de Desenvolvimento](docs/DEVELOPMENT.md)
- [Guia de Deploy](docs/DEPLOYMENT.md)
- [README Principal](README.md)

## 🆘 Precisa de Ajuda?

```bash
# Ver comandos disponíveis
make help

# Executar setup automático
./scripts/setup.sh

# Verificar qualidade
make quality
```

---

**🎉 Boa programação com Laravel!**
