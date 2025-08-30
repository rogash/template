# 🚀 Guia de Desenvolvimento

Este documento contém informações detalhadas para desenvolvedores trabalhando com este template Laravel.

## 📋 Índice

1. [Configuração do Ambiente](#configuração-do-ambiente)
2. [Estrutura do Projeto](#estrutura-do-projeto)
3. [Padrões de Código](#padrões-de-código)
4. [Ferramentas de Qualidade](#ferramentas-de-qualidade)
5. [Testes](#testes)
6. [Docker](#docker)
7. [Deploy](#deploy)
8. [Troubleshooting](#troubleshooting)

## 🛠️ Configuração do Ambiente

### Requisitos Mínimos

- **PHP**: 8.4+
- **Composer**: 2.6+
- **Node.js**: 18+
- **Docker**: 20.10+ (opcional, para Laravel Sail)
- **Git**: 2.30+

### Instalação Local

```bash
# Clone o repositório
git clone <url-do-repositorio>
cd <nome-do-projeto>

# Execute o script de setup
./scripts/setup.sh

# Ou configure manualmente
cp env.example .env
composer install
npm install
php artisan key:generate
```

### Configuração do IDE

#### VS Code

Instale as seguintes extensões:
- PHP Intelephense
- Laravel Blade Snippets
- PHP Debug
- PHP CS Fixer
- PHP IntelliSense
- Tailwind CSS IntelliSense

#### PHPStorm

- Configure o PHP 8.4 como interpretador
- Ative o Laravel Plugin
- Configure o PHP CS Fixer
- Configure o PHPStan

## 🏗️ Estrutura do Projeto

### Diretórios Principais

```
app/
├── Console/           # Comandos Artisan customizados
├── Exceptions/        # Tratamento de exceções
├── Http/              # Controllers, Middleware, Requests
│   ├── Controllers/   # Controllers da aplicação
│   ├── Middleware/    # Middleware customizado
│   ├── Requests/      # Form Requests para validação
│   └── Resources/     # API Resources
├── Models/            # Modelos Eloquent
├── Providers/         # Service Providers
├── Services/          # Lógica de negócio
└── Traits/            # Traits reutilizáveis

config/                # Arquivos de configuração
database/              # Migrações, seeders, factories
├── factories/         # Factories para testes
├── migrations/        # Migrações do banco
└── seeders/           # Seeders para dados iniciais

routes/                # Definição de rotas
├── api.php           # Rotas da API
├── channels.php      # Broadcast channels
├── console.php       # Comandos Artisan
└── web.php           # Rotas web

storage/               # Arquivos gerados pela aplicação
├── app/              # Arquivos da aplicação
├── framework/        # Cache, logs, sessions
└── logs/             # Logs da aplicação

tests/                 # Testes automatizados
├── Feature/          # Testes de funcionalidade
├── Unit/             # Testes unitários
└── TestCase.php      # Classe base para testes
```

## 📝 Padrões de Código

### PSR-12

Este projeto segue estritamente o padrão PSR-12. Use as ferramentas configuradas para manter a consistência:

```bash
# Verificar estilo
make cs-check

# Corrigir automaticamente
make cs-fix

# Formatar com Pint
make pint
```

### Convenções de Nomenclatura

#### Classes
- **Controllers**: `UserController`, `PostController`
- **Models**: `User`, `Post`, `Comment`
- **Services**: `UserService`, `EmailService`
- **Repositories**: `UserRepository`, `PostRepository`

#### Métodos
- **Controllers**: `index()`, `show()`, `store()`, `update()`, `destroy()`
- **Services**: `createUser()`, `sendEmail()`, `processPayment()`

#### Variáveis
- **Camel Case**: `$userName`, `$postTitle`
- **Boolean**: `$isActive`, `$hasPermission`

### Estrutura de Arquivos

#### Controller Example
```php
<?php

namespace App\Http\Controllers;

use App\Http\Requests\UserRequest;
use App\Models\User;
use App\Services\UserService;
use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    public function __construct(
        private readonly UserService $userService
    ) {}

    public function index(): JsonResponse
    {
        $users = $this->userService->getAllUsers();

        return response()->json($users);
    }

    public function store(UserRequest $request): JsonResponse
    {
        $user = $this->userService->createUser($request->validated());

        return response()->json($user, 201);
    }
}
```

#### Service Example
```php
<?php

namespace App\Services;

use App\Models\User;
use App\Repositories\UserRepository;
use Illuminate\Support\Facades\Hash;

class UserService
{
    public function __construct(
        private readonly UserRepository $userRepository
    ) {}

    public function createUser(array $data): User
    {
        $data['password'] = Hash::make($data['password']);

        return $this->userRepository->create($data);
    }

    public function updateUser(User $user, array $data): User
    {
        if (isset($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        }

        return $this->userRepository->update($user, $data);
    }
}
```

## 🔍 Ferramentas de Qualidade

### PHPStan

**Configuração**: `phpstan.neon`
**Level**: 8 (máximo rigor)

```bash
# Análise completa
make stan

# Análise específica
phpstan analyse app/Models

# Com configuração customizada
phpstan analyse --configuration=phpstan.neon app/
```

### Psalm

**Configuração**: `psalm.xml`
**Error Level**: 4 (equilibrado)

```bash
# Análise completa
make psalm

# Análise com baseline
psalm --update-baseline

# Análise específica
psalm --show-info=false app/Models/
```

### Laravel Pint

**Configuração**: `pint.json`
**Preset**: Laravel + customizações

```bash
# Formatar código
make pint

# Verificar sem alterar
./vendor/bin/pint --test

# Formatar arquivo específico
./vendor/bin/pint app/Models/User.php
```

### PHP CS Fixer

**Configuração**: `.php-cs-fixer.php`
**Standard**: PSR-12

```bash
# Verificar estilo
make cs-check

# Corrigir automaticamente
make cs-fix

# Verificar arquivo específico
./vendor/bin/phpcs --standard=PSR12 app/Models/User.php
```

## 🧪 Testes

### Estrutura de Testes

```
tests/
├── Feature/          # Testes de funcionalidade
│   ├── Auth/        # Testes de autenticação
│   ├── User/        # Testes de usuário
│   └── Api/         # Testes da API
├── Unit/             # Testes unitários
│   ├── Models/      # Testes de modelos
│   ├── Services/    # Testes de serviços
│   └── Helpers/     # Testes de helpers
└── TestCase.php      # Classe base
```

### Executando Testes

```bash
# Todos os testes
make test

# Testes com cobertura
make test-coverage

# Testes específicos
php artisan test --filter=UserTest
php artisan test tests/Feature/User/

# Testes em paralelo
php artisan test --parallel
```

### Exemplo de Teste

```php
<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_create_user(): void
    {
        $userData = [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123',
        ];

        $response = $this->postJson('/api/users', $userData);

        $response->assertStatus(201)
                ->assertJsonStructure([
                    'id',
                    'name',
                    'email',
                    'created_at',
                ]);

        $this->assertDatabaseHas('users', [
            'email' => 'john@example.com',
        ]);
    }

    public function test_cannot_create_user_with_invalid_email(): void
    {
        $userData = [
            'name' => 'John Doe',
            'email' => 'invalid-email',
            'password' => 'password123',
        ];

        $response = $this->postJson('/api/users', $userData);

        $response->assertStatus(422)
                ->assertJsonValidationErrors(['email']);
    }
}
```

## 🐳 Docker

### Laravel Sail

```bash
# Iniciar serviços
make sail-up

# Parar serviços
make sail-down

# Shell do container
make sail-shell

# Comandos Artisan
./vendor/bin/sail artisan migrate
./vendor/bin/sail test
```

### Serviços Disponíveis

- **Laravel**: http://localhost
- **MySQL**: localhost:3306
- **Redis**: localhost:6379
- **Meilisearch**: http://localhost:7700
- **Mailpit**: http://localhost:8025

### Docker Compose Customizado

```bash
# Desenvolvimento
docker-compose up -d

# Produção
docker-compose -f docker-compose.prod.yml up -d
```

## 🚀 Deploy

### Script de Deploy

```bash
# Execute como root
sudo ./scripts/deploy.sh
```

### Deploy Manual

```bash
# 1. Clone/Update código
git pull origin main

# 2. Instalar dependências
composer install --no-dev --optimize-autoloader
npm ci --production

# 3. Build assets
npm run build

# 4. Configurar permissões
chown -R www-data:www-data /var/www/laravel
chmod -R 755 storage bootstrap/cache

# 5. Limpar caches
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 6. Executar migrações
php artisan migrate --force

# 7. Reiniciar serviços
systemctl restart nginx
systemctl restart php8.4-fpm
```

## 🔧 Troubleshooting

### Problemas Comuns

#### Erro de Memória no PHPStan
```bash
# Aumentar limite de memória
phpstan analyse --memory-limit=4G
```

#### Problemas com Docker
```bash
# Reconstruir containers
make sail-build

# Limpar volumes
./vendor/bin/sail down -v
```

#### Cache Corrompido
```bash
# Limpar todos os caches
make cache-clear
```

#### Problemas de Permissão
```bash
# Corrigir permissões
chmod -R 755 storage bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
```

### Logs

- **Laravel**: `storage/logs/laravel.log`
- **Nginx**: `/var/log/nginx/error.log`
- **PHP-FPM**: `/var/log/php8.4-fpm.log`

### Debug

```bash
# Ativar debug
php artisan config:cache
php artisan config:clear

# Ver rotas
php artisan route:list

# Ver configurações
php artisan config:show
```

## 📚 Recursos Adicionais

### Comandos Úteis

```bash
# Ver todos os comandos
make help

# Verificação completa de qualidade
make quality

# Desenvolvimento
make watch
make build

# Gerenciamento
make fresh
make optimize
```

### Links Úteis

- [Laravel Documentation](https://laravel.com/docs)
- [PHPStan Documentation](https://phpstan.org/)
- [Psalm Documentation](https://psalm.dev/)
- [Laravel Pint](https://laravel.com/docs/pint)
- [Laravel Sail](https://laravel.com/docs/sail)

---

**Última atualização**: $(date +%Y-%m-%d)
