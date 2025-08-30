# 🚀 Template Laravel - Template para Desenvolvimento

Um template completo e moderno para desenvolvimento de aplicações Laravel com as melhores práticas, ferramentas de qualidade de código e configurações otimizadas.

## ✨ Características

- **Laravel 12** - Framework mais recente e estável
- **PHP 8.4** - Última versão do PHP com todas as funcionalidades modernas
- **Docker + Laravel Sail** - Ambiente de desenvolvimento isolado e reproduzível
- **Análise Estática** - PHPStan + Psalm para detecção de bugs
- **Formatação de Código** - Laravel Pint + PHP CS Fixer para PSR-12
- **Testes** - PHPUnit configurado e pronto para uso
- **Qualidade de Código** - Scripts automatizados para verificação de qualidade

## 🛠️ Pré-requisitos

- **PHP**: 8.4+
- **Composer**: 2.6+
- **Node.js**: 18+
- **Docker & Docker Compose** (para Laravel Sail)
- **Git**: 2.30+

## 🚀 Instalação Rápida

### 1. Clone o repositório
```bash
git clone <seu-repositorio>
cd <nome-do-projeto>
```

### 2. Configuração inicial
```bash
# Copia arquivo de ambiente
cp env.example .env

# Instala dependências
composer install
npm install

# Gera chave da aplicação
php artisan key:generate

# Executa migrações
php artisan migrate

# Popula banco com dados de teste
php artisan db:seed
```

### 3. Inicia o servidor
```bash
# Desenvolvimento local
php artisan serve

# Ou com Docker (recomendado)
./vendor/bin/sail up -d
```

## 🐳 Usando Laravel Sail (Docker)

### Comandos básicos
```bash
# Inicia todos os serviços
./vendor/bin/sail up -d

# Para os serviços
./vendor/bin/sail down

# Acessa o shell do container
./vendor/bin/sail shell

# Executa comandos Artisan
./vendor/bin/sail artisan migrate

# Executa testes
./vendor/bin/sail test
```

### Serviços disponíveis
- **Laravel**: http://localhost
- **MySQL**: localhost:3306
- **Redis**: localhost:6379
- **Meilisearch**: http://localhost:7700
- **Mailpit**: http://localhost:8025
- **Selenium**: localhost:4444

## 🔍 Ferramentas de Qualidade

### Análise Estática

#### PHPStan
```bash
# Análise completa
make stan
# ou
phpstan analyse --memory-limit=2G

# Análise específica
phpstan analyse app/Models
```

#### Psalm
```bash
# Análise completa
make psalm
# ou
psalm

# Análise com baseline
psalm --update-baseline
```

### Formatação de Código

#### Laravel Pint
```bash
# Formata código
make pint
# ou
./vendor/bin/pint

# Verifica sem alterar
./vendor/bin/pint --test
```

#### PHP CS Fixer
```bash
# Verifica estilo
make cs-check
# ou
./vendor/bin/phpcs --standard=PSR12 app/

# Corrige automaticamente
make cs-fix
# ou
./vendor/bin/phpcbf --standard=PSR12 app/
```

### Testes
```bash
# Executa todos os testes
make test
# ou
php artisan test

# Testes com cobertura
make test-coverage
# ou
php artisan test --coverage

# Testes específicos
php artisan test --filter=UserTest
```

## 📋 Comandos Makefile

O projeto inclui um Makefile com comandos úteis:

```bash
# Ver todos os comandos disponíveis
make help

# Configuração inicial
make setup

# Verificação completa de qualidade
make quality

# Gerenciamento de cache
make cache-clear
make optimize

# Desenvolvimento
make watch
make build
```

## 🏗️ Estrutura do Projeto

```
├── app/                    # Código da aplicação
│   ├── Console/           # Comandos Artisan
│   ├── Exceptions/        # Tratamento de exceções
│   ├── Http/              # Controllers, Middleware, Requests
│   ├── Models/            # Modelos Eloquent
│   ├── Providers/         # Service Providers
│   └── Services/          # Lógica de negócio
├── config/                # Arquivos de configuração
├── database/              # Migrações, seeders, factories
├── routes/                # Definição de rotas
├── storage/               # Arquivos gerados pela aplicação
├── tests/                 # Testes automatizados
├── vendor/                # Dependências Composer
├── .env.example          # Exemplo de variáveis de ambiente
├── composer.json         # Dependências PHP
├── docker-compose.yml    # Configuração Docker
├── Makefile              # Comandos úteis
├── phpstan.neon         # Configuração PHPStan
├── psalm.xml            # Configuração Psalm
├── pint.json            # Configuração Laravel Pint
└── phpcs.xml            # Configuração PHP_CodeSniffer
```

## 🔧 Configurações

### PHPStan
- **Level**: 8 (máximo rigor)
- **Paths**: app, config, database, routes, tests
- **Extensions**: Larastan para Laravel

### Psalm
- **Error Level**: 4 (equilibrado)
- **Plugin**: Laravel
- **Memory Limit**: 2GB

### Laravel Pint
- **Preset**: Laravel
- **Rules**: PSR-12 + customizações
- **Paths**: app, config, database, routes, tests

### PHP CS Fixer
- **Standard**: PSR-12
- **Rules**: Customizadas para Laravel
- **Auto-fix**: Habilitado

## 🚀 Workflow de Desenvolvimento

### 1. Desenvolvimento
```bash
# Inicia ambiente
make sail-up

# Desenvolvimento com hot-reload
make watch
```

### 2. Antes do Commit
```bash
# Verificação completa de qualidade
make quality

# Ou individualmente
make stan
make psalm
make pint
make test
```

### 3. Deploy
```bash
# Otimiza para produção
make optimize

# Compila assets
make build
```

## 📚 Recursos Adicionais

### Composer Scripts
```bash
# Análise estática
composer analyse

# Formatação
composer pint

# Verificação de estilo
composer cs-check
composer cs-fix

# Qualidade completa
composer quality
```

### IDE Support
- **PHPStorm**: Configurações incluídas
- **VS Code**: Extensões recomendadas
- **Vim/Neovim**: Configurações disponíveis

## 🐛 Solução de Problemas

### Erro de memória no PHPStan
```bash
# Aumenta limite de memória
phpstan analyse --memory-limit=4G
```

### Problemas com Docker
```bash
# Reconstrói containers
make sail-build

# Limpa volumes
./vendor/bin/sail down -v
```

### Cache corrompido
```bash
# Limpa todos os caches
make cache-clear
```

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está licenciado sob a Licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🙏 Agradecimentos

- [Laravel Team](https://laravel.com/) - Framework incrível
- [PHPStan](https://phpstan.org/) - Análise estática
- [Psalm](https://psalm.dev/) - Análise adicional
- [Laravel Pint](https://laravel.com/docs/pint) - Formatação de código
- [Laravel Sail](https://laravel.com/docs/sail) - Docker para Laravel

---

**Desenvolvido com ❤️ para a comunidade Laravel**
