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
- **Docker & Docker Compose** (opcional, para Laravel Sail)
- **Git**: 2.30+

## 🚀 Como Usar o Template

### **Opção 1: Usar como Base para Novos Projetos (RECOMENDADA)**

Este template foi projetado para ser usado como **base para novos projetos**. É a abordagem mais limpa e profissional:

```bash
# 1. Clone o template
git clone <url-do-template> meu-projeto
cd meu-projeto

# 2. Crie um novo projeto Laravel a partir do template
./scripts/create-project.sh

# 3. Escolha onde criar o projeto:
#    - Na pasta atual (dentro do template)
#    - Em uma pasta específica (recomendado)
#    - Em uma pasta pai (../)

# 4. Siga as instruções na tela
# O script criará o projeto no local escolhido com Laravel + todas as configurações
```

**Vantagens desta abordagem:**
- ✅ Mantém o template intacto para reutilização
- ✅ Cria projetos limpos e organizados
- ✅ Preserva histórico do Git
- ✅ Fácil de manter e atualizar
- ✅ **Permite licenças próprias** - LICENSE não é copiada automaticamente

### **📋 Estrutura do Template**

O template **NÃO contém** o Laravel instalado, apenas as configurações e ferramentas:

```
template/
├── scripts/           # Scripts de criação de projetos
├── docs/             # Documentação
├── docker/           # Configurações Docker
├── .github/          # GitHub Actions
├── composer.json     # Dependências das ferramentas (PHPStan, Psalm, etc.)
├── package.json      # Dependências Node.js
├── phpstan.neon      # Configuração PHPStan para template
├── psalm.xml         # Configuração Psalm para template
├── .cursorrules      # Regras para IA
└── README.md         # Esta documentação
```

**🔧 Configurações Automáticas:**
- **Template**: Configurações para arquivos do template
- **Projetos Criados**: Configurações automaticamente ajustadas para Laravel
- **Sem Intervenção Manual**: Tudo funciona "out of the box"

**✅ Vantagens:**
- Template limpo e organizado
- Fácil de manter e atualizar
- Não interfere com projetos criados
- Permite reutilização infinita
- **Repositórios independentes** - Cada projeto tem seu próprio Git
- **Histórico limpo** - Sem herança do template

### **Opção 2: Instalar Laravel no Template Atual**

Se você quiser usar o template diretamente (não recomendado para produção):

```bash
# Execute o script de setup (instala Laravel 12 no diretório atual)
./scripts/setup.sh

# Ou configure manualmente
./scripts/install-laravel.sh  # Instala Laravel 12
composer install               # Instala dependências PHP
npm install                    # Instala dependências Node.js
cp .env.example .env          # Copia arquivo de ambiente
php artisan key:generate      # Gera chave da aplicação
```

**⚠️ Atenção:** Esta opção modifica o template original.

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
./vendor/bin/psalm --no-progress

# Análise específica
./vendor/bin/psalm app/Models
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

## ��️ Estrutura do Projeto

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
- **Extensions**: Larastan (larastan/larastan) para Laravel

### Psalm
- **Error Level**: 4 (rigoroso)
- **Version**: 6.13 (estável e madura)
- **Paths**: app, config, database, routes, tests
- **Plugin**: Laravel Plugin para suporte específico

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

### ⚖️ Sobre Licenças em Novos Projetos

**Importante**: Quando você cria um novo projeto usando este template:

- ✅ **Template**: Mantém a licença MIT
- ✅ **Novos Projetos**: Podem ter suas próprias licenças
- ✅ **Comercial**: Permite projetos proprietários e comerciais
- ✅ **Flexibilidade**: Escolha a licença que melhor se adequa ao seu projeto

O script `create-project.sh` **não copia** automaticamente a LICENSE do template, permitindo que você defina a licença apropriada para seu projeto.

## 🙏 Agradecimentos

- [Laravel Team](https://laravel.com/) - Framework incrível
- [PHPStan](https://phpstan.org/) - Análise estática
- [Psalm](https://psalm.dev/) - Análise estática complementar
- [Laravel Pint](https://laravel.com/docs/pint) - Formatação de código
- [Laravel Sail](https://laravel.com/docs/sail) - Docker para Laravel

---

**Desenvolvido com ❤️ para a comunidade Laravel**
