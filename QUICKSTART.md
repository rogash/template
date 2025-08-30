# 🚀 Quick Start - Template Laravel

Guia rápido para começar com o template Laravel em minutos!

## 🎯 **Escolha sua Abordagem**

### **🚀 Opção 1: Criar Novo Projeto (RECOMENDADA)**

```bash
# 1. Clone o template
git clone <url-do-template> meu-projeto
cd meu-projeto

# 2. Crie um novo projeto Laravel
./scripts/create-project.sh

# 3. Siga as instruções na tela
# O script criará uma nova pasta com Laravel + template
```

**✅ Vantagens:**
- Template permanece intacto
- Projeto limpo e organizado
- Fácil de reutilizar
- **Permite licenças próprias** (LICENSE não é copiada)

### **⚠️ Opção 2: Usar Template Diretamente**

```bash
# Clone e configure no diretório atual
git clone <url-do-template> .
./scripts/setup.sh
```

**⚠️ Atenção:** Modifica o template original.

## 🔧 **Configuração Rápida**

### **1. Ambiente**
```bash
# Copia arquivo de ambiente
cp .env.example .env

# Gera chave da aplicação
php artisan key:generate
```

### **2. Banco de Dados**
```bash
# Configura .env com suas credenciais
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=seu_banco
DB_USERNAME=seu_usuario
DB_PASSWORD=sua_senha

# Executa migrações
php artisan migrate
```

### **3. Inicia o Servidor**
```bash
# Desenvolvimento local
php artisan serve

# Ou com Docker (recomendado)
./vendor/bin/sail up -d
```

## 🐳 **Docker (Laravel Sail)**

```bash
# Inicia todos os serviços
./vendor/bin/sail up -d

# Para os serviços
./vendor/bin/sail down

# Shell do container
./vendor/bin/sail shell

# Comandos Artisan
./vendor/bin/sail artisan migrate
```

## 🔍 **Ferramentas de Qualidade**

### **Verificação Completa**
```bash
# Todas as verificações
make quality
```

### **Individualmente**
```bash
# Análise estática
make stan          # PHPStan
make psalm         # Psalm

# Formatação
make pint          # Laravel Pint
make cs-check      # Verificar PSR-12
make cs-fix        # Corrigir PSR-12

# Testes
make test          # PHPUnit
```

## 📚 **Comandos Essenciais**

```bash
# Ver todos os comandos
make help

# Setup inicial
make setup

# Desenvolvimento
make watch         # Hot reload
make build         # Compilar assets

# Cache
make cache-clear   # Limpar cache
make optimize      # Otimizar produção
```

## 🌐 **Acessos**

- **Laravel**: http://localhost
- **MySQL**: localhost:3306
- **Redis**: localhost:6379
- **Meilisearch**: http://localhost:7700
- **Mailpit**: http://localhost:8025

## 📖 **Documentação**

- **README.md** - Documentação completa
- **docs/DEVELOPMENT.md** - Guia para desenvolvedores
- **docs/DEPLOYMENT.md** - Guia de deploy
- **CHANGELOG.md** - Histórico de mudanças

---

**🎉 Pronto! Seu projeto Laravel está configurado com todas as melhores práticas!**
