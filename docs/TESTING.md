# 🧪 Guia de Testes - Template Laravel

## 📋 Visão Geral

Este template inclui configurações e exemplos para implementar testes robustos em seus projetos Laravel.

## 🚀 Tipos de Testes Disponíveis

### **1. Testes Unitários (PHPUnit)**
```bash
# Executar todos os testes
php artisan test

# Executar testes específicos
php artisan test --filter=UserTest

# Executar com cobertura
php artisan test --coverage
```

### **2. Testes de Browser (Laravel Dusk)**
```bash
# Instalar dependências
composer require --dev laravel/dusk

# Publicar configurações
php artisan dusk:install

# Executar testes Dusk
php artisan dusk

# Executar testes específicos
php artisan dusk --filter=LoginTest
```

### **3. Testes de API**
```bash
# Exemplo de teste de API
php artisan make:test Api/UserApiTest

# Executar testes de API
php artisan test --filter=Api
```

### **4. Testes de Performance**
```bash
# Instalar ferramenta de performance
composer require --dev k6s/phpunit-k6

# Executar testes de performance
php artisan test --filter=Performance
```

## 📁 Estrutura de Testes Recomendada

```
tests/
├── Unit/                    # Testes unitários
│   ├── Models/             # Testes de models
│   ├── Services/           # Testes de services
│   └── Helpers/            # Testes de helpers
├── Feature/                 # Testes de funcionalidades
│   ├── Auth/               # Testes de autenticação
│   ├── Api/                # Testes de API
│   └── Web/                # Testes de web
├── Browser/                 # Testes de browser (Dusk)
│   ├── Pages/              # Page objects
│   └── Components/         # Componentes reutilizáveis
└── Performance/             # Testes de performance
    ├── Load/                # Testes de carga
    └── Stress/              # Testes de estresse
```

## 🎯 Exemplos de Testes

### **Teste de Model**
```php
<?php

namespace Tests\Unit\Models;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_create_user(): void
    {
        $user = User::factory()->create([
            'name' => 'John Doe',
            'email' => 'john@example.com'
        ]);

        $this->assertInstanceOf(User::class, $user);
        $this->assertEquals('John Doe', $user->name);
        $this->assertEquals('john@example.com', $user->email);
    }

    public function test_user_has_full_name(): void
    {
        $user = User::factory()->create([
            'first_name' => 'John',
            'last_name' => 'Doe'
        ]);

        $this->assertEquals('John Doe', $user->full_name);
    }
}
```

### **Teste de API**
```php
<?php

namespace Tests\Feature\Api;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_can_get_users_list(): void
    {
        User::factory()->count(3)->create();

        $response = $this->getJson('/api/users');

        $response->assertStatus(200)
                ->assertJsonStructure([
                    'data' => [
                        '*' => [
                            'id',
                            'name',
                            'email',
                            'created_at'
                        ]
                    ]
                ]);
    }

    public function test_can_create_user(): void
    {
        $userData = [
            'name' => 'John Doe',
            'email' => 'john@example.com',
            'password' => 'password123'
        ];

        $response = $this->postJson('/api/users', $userData);

        $response->assertStatus(201)
                ->assertJsonStructure([
                    'data' => [
                        'id',
                        'name',
                        'email',
                        'created_at'
                    ]
                ]);

        $this->assertDatabaseHas('users', [
            'email' => 'john@example.com'
        ]);
    }
}
```

### **Teste de Browser (Dusk)**
```php
<?php

namespace Tests\Browser;

use App\Models\User;
use Illuminate\Foundation\Testing\DatabaseMigrations;
use Laravel\Dusk\Browser;
use Tests\DuskTestCase;

class LoginTest extends DuskTestCase
{
    use DatabaseMigrations;

    public function test_user_can_login(): void
    {
        $user = User::factory()->create([
            'email' => 'john@example.com',
            'password' => bcrypt('password123')
        ]);

        $this->browse(function (Browser $browser) use ($user) {
            $browser->visit('/login')
                    ->type('email', 'john@example.com')
                    ->type('password', 'password123')
                    ->press('Login')
                    ->assertPathIs('/dashboard')
                    ->assertSee('Welcome back!');
        });
    }
}
```

## 🔧 Configurações de Teste

### **phpunit.xml**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="vendor/phpunit/phpunit/phpunit.xsd"
         bootstrap="vendor/autoload.php"
         colors="true"
         processIsolation="false"
         stopOnFailure="false">
    <testsuites>
        <testsuite name="Unit">
            <directory>tests/Unit</directory>
        </testsuite>
        <testsuite name="Feature">
            <directory>tests/Feature</directory>
        </testsuite>
        <testsuite name="Browser">
            <directory>tests/Browser</directory>
        </testsuite>
    </testsuites>
    <source>
        <include>
            <directory>app</directory>
        </include>
    </source>
    <coverage>
        <report>
            <html outputDirectory="coverage"/>
            <clover outputFile="coverage.xml"/>
        </report>
    </coverage>
</phpunit>
```

### **.env.testing**
```env
APP_ENV=testing
APP_DEBUG=true
DB_CONNECTION=sqlite
DB_DATABASE=:memory:
CACHE_DRIVER=array
SESSION_DRIVER=array
QUEUE_DRIVER=sync
```

## 📊 Relatórios de Cobertura

### **Gerar Relatório HTML**
```bash
php artisan test --coverage-html coverage
```

### **Gerar Relatório XML (CI/CD)**
```bash
php artisan test --coverage-clover coverage.xml
```

### **Verificar Cobertura no Terminal**
```bash
php artisan test --coverage-text
```

## 🚀 Integração com CI/CD

### **GitHub Actions**
```yaml
- name: Run Tests
  run: php artisan test --coverage-clover coverage.xml

- name: Upload Coverage
  uses: codecov/codecov-action@v3
  with:
    file: ./coverage.xml
```

## 💡 Dicas de Teste

### **1. Use Factories**
```php
// Criar dados de teste consistentes
$user = User::factory()->create();
$users = User::factory()->count(5)->create();
```

### **2. Use Database Transactions**
```php
use Illuminate\Foundation\Testing\DatabaseTransactions;

class UserTest extends TestCase
{
    use DatabaseTransactions; // Rollback automático
}
```

### **3. Teste Edge Cases**
```php
public function test_cannot_create_user_with_invalid_email(): void
{
    $response = $this->postJson('/api/users', [
        'email' => 'invalid-email'
    ]);

    $response->assertStatus(422)
            ->assertJsonValidationErrors(['email']);
}
```

### **4. Use Mocks para Dependências Externas**
```php
use Mockery;

public function test_user_service_calls_external_api(): void
{
    $mockApi = Mockery::mock(ExternalApiService::class);
    $mockApi->shouldReceive('send')->once()->andReturn(true);

    $service = new UserService($mockApi);
    $result = $service->createUser($userData);

    $this->assertTrue($result);
}
```

## 🎯 Próximos Passos

1. **Configure o ambiente de teste**
2. **Crie factories para seus models**
3. **Implemente testes unitários básicos**
4. **Adicione testes de API**
5. **Configure testes de browser (se necessário)**
6. **Implemente testes de performance**

## 📚 Recursos Adicionais

- [Laravel Testing Documentation](https://laravel.com/docs/testing)
- [PHPUnit Documentation](https://phpunit.de/)
- [Laravel Dusk Documentation](https://laravel.com/docs/dusk)
- [Testing Best Practices](https://laravel.com/docs/testing#testing-best-practices)

---

**🎉 Com este guia, seus projetos terão uma base sólida de testes!**
