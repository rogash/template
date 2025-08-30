# 🚀 Guia de Deploy e Produção - Laravel

Este documento contém informações detalhadas sobre como fazer deploy da aplicação Laravel em diferentes ambientes.

## 📋 Índice

1. [Preparação para Produção](#preparação-para-produção)
2. [Deploy com Docker](#deploy-com-docker)
3. [Deploy Tradicional](#deploy-tradicional)
4. [Configuração do Servidor](#configuração-do-servidor)
5. [Monitoramento](#monitoramento)
6. [Backup e Recuperação](#backup-e-recuperação)
7. [Segurança](#segurança)

## 🔧 Preparação para Produção

### Configurações de Ambiente

Antes do deploy, certifique-se de configurar corretamente o arquivo `.env`:

```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://seudominio.com

LOG_CHANNEL=stack
LOG_LEVEL=error

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel_prod
DB_USERNAME=laravel_user
DB_PASSWORD=senha_forte_aqui

CACHE_DRIVER=redis
QUEUE_CONNECTION=redis
SESSION_DRIVER=redis

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=seu@email.com
MAIL_PASSWORD=sua_senha_app
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS="noreply@seudominio.com"
MAIL_FROM_NAME="${APP_NAME}"
```

### Otimizações de Produção

```bash
# Cache de configurações
php artisan config:cache

# Cache de rotas
php artisan route:cache

# Cache de views
php artisan view:cache

# Otimizar autoloader
composer install --optimize-autoloader --no-dev

# Build de assets
npm run build
```

## 🐳 Deploy com Docker

### Usando Docker Compose

```bash
# 1. Clone o repositório
git clone <seu-repositorio>
cd <nome-do-projeto>

# 2. Configure o ambiente
cp env.example .env
# Edite o .env com as configurações de produção

# 3. Deploy
docker-compose -f docker-compose.prod.yml up -d

# 4. Execute migrações
docker-compose -f docker-compose.prod.yml exec app php artisan migrate --force

# 5. Configure permissões
docker-compose -f docker-compose.prod.yml exec app chown -R www-data:www-data /var/www
```

### Script de Deploy Automatizado

```bash
# Execute como root
sudo ./scripts/deploy.sh
```

### Configuração do Dockerfile

O Dockerfile está configurado para PHP 8.4 com todas as extensões necessárias:

```dockerfile
FROM php:8.4-fpm

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    supervisor \
    nginx \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Instala Redis
RUN pecl install redis && docker-php-ext-enable redis

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

# Copia aplicação
COPY . /var/www

# Configura permissões
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage \
    && chmod -R 755 /var/www/bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]
```

## 🖥️ Deploy Tradicional

### Requisitos do Servidor

- **Sistema Operacional**: Ubuntu 22.04 LTS ou CentOS 8+
- **PHP**: 8.4+
- **Web Server**: Nginx ou Apache
- **Database**: MySQL 8.0+ ou PostgreSQL 13+
- **Cache**: Redis 6+
- **SSL**: Certificado válido (Let's Encrypt)

### Instalação de Dependências

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y nginx mysql-server redis-server php8.4-fpm php8.4-mysql php8.4-redis php8.4-xml php8.4-mbstring php8.4-zip php8.4-gd php8.4-curl php8.4-bcmath php8.4-intl

# CentOS/RHEL
sudo yum install -y nginx mysql-server redis php-fpm php-mysql php-redis php-xml php-mbstring php-zip php-gd php-curl php-bcmath php-intl
```

### Configuração do Nginx

```nginx
server {
    listen 80;
    server_name seudominio.com www.seudominio.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name seudominio.com www.seudominio.com;

    ssl_certificate /etc/letsencrypt/live/seudominio.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/seudominio.com/privkey.pem;

    root /var/www/laravel/public;
    index index.php index.html index.htm;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_proxied expired no-cache no-store private must-revalidate auth;
    gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }

    # Cache static files
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|pdf|txt)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

### Configuração do PHP-FPM

```ini
# /etc/php/8.4/fpm/php.ini
upload_max_filesize = 64M
post_max_size = 64M
memory_limit = 512M
max_execution_time = 300
max_input_vars = 3000

# Opcache para performance
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=10000
opcache.revalidate_freq=2
opcache.fast_shutdown=1
```

### Deploy Manual

```bash
# 1. Acesse o servidor
ssh usuario@seu-servidor

# 2. Clone/Update o repositório
cd /var/www
git clone <seu-repositorio> laravel
cd laravel

# 3. Configure o ambiente
cp env.example .env
# Edite o .env

# 4. Instale dependências
composer install --no-dev --optimize-autoloader
npm ci --production

# 5. Build assets
npm run build

# 6. Configure permissões
sudo chown -R www-data:www-data /var/www/laravel
sudo chmod -R 755 storage bootstrap/cache

# 7. Gere chave da aplicação
php artisan key:generate

# 8. Execute migrações
php artisan migrate --force

# 9. Otimize para produção
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 10. Reinicie serviços
sudo systemctl restart nginx
sudo systemctl restart php8.4-fpm
```

## ⚙️ Configuração do Servidor

### Configuração do MySQL

```sql
-- Criar usuário e banco
CREATE DATABASE laravel_prod CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'laravel_user'@'localhost' IDENTIFIED BY 'senha_forte_aqui';
GRANT ALL PRIVILEGES ON laravel_prod.* TO 'laravel_user'@'localhost';
FLUSH PRIVILEGES;

-- Configurações de performance
SET GLOBAL innodb_buffer_pool_size = 1073741824; -- 1GB
SET GLOBAL innodb_log_file_size = 268435456; -- 256MB
SET GLOBAL innodb_flush_log_at_trx_commit = 2;
SET GLOBAL innodb_flush_method = 'O_DIRECT';
```

### Configuração do Redis

```conf
# /etc/redis/redis.conf
maxmemory 256mb
maxmemory-policy allkeys-lru
save 900 1
save 300 10
save 60 10000
```

### Configuração do Supervisor (para Filas)

```ini
# /etc/supervisor/conf.d/laravel-worker.conf
[program:laravel-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/laravel/artisan queue:work redis --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
stopasgroup=true
killasgroup=true
user=www-data
numprocs=8
redirect_stderr=true
stdout_logfile=/var/www/laravel/storage/logs/worker.log
stopwaitsecs=3600
```

## 📊 Monitoramento

### Logs

```bash
# Logs do Laravel
tail -f /var/www/laravel/storage/logs/laravel.log

# Logs do Nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Logs do PHP-FPM
sudo tail -f /var/log/php8.4-fpm.log

# Logs do MySQL
sudo tail -f /var/log/mysql/error.log

# Logs do Redis
sudo tail -f /var/log/redis/redis-server.log
```

### Monitoramento de Performance

```bash
# Status dos serviços
sudo systemctl status nginx
sudo systemctl status php8.4-fpm
sudo systemctl status mysql
sudo systemctl status redis

# Uso de recursos
htop
df -h
free -h

# Status do MySQL
mysql -u root -p -e "SHOW STATUS LIKE 'Threads_connected';"
mysql -u root -p -e "SHOW PROCESSLIST;"
```

### Ferramentas de Monitoramento

- **Laravel Telescope**: Para debug em desenvolvimento
- **Laravel Horizon**: Para monitoramento de filas
- **New Relic**: Para APM
- **Datadog**: Para monitoramento completo
- **Prometheus + Grafana**: Para métricas customizadas

## 💾 Backup e Recuperação

### Backup do Banco de Dados

```bash
#!/bin/bash
# /usr/local/bin/backup-db.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/mysql"
DB_NAME="laravel_prod"
DB_USER="laravel_user"
DB_PASS="senha_forte_aqui"

mkdir -p $BACKUP_DIR

mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/backup_$DATE.sql

# Comprimir
gzip $BACKUP_DIR/backup_$DATE.sql

# Manter apenas os últimos 7 backups
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete

echo "Backup criado: backup_$DATE.sql.gz"
```

### Backup dos Arquivos

```bash
#!/bin/bash
# /usr/local/bin/backup-files.sh

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/files"
APP_DIR="/var/www/laravel"

mkdir -p $BACKUP_DIR

tar -czf $BACKUP_DIR/app_$DATE.tar.gz -C $APP_DIR .

# Manter apenas os últimos 7 backups
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup criado: app_$DATE.tar.gz"
```

### Cron para Backups Automáticos

```bash
# /etc/cron.d/laravel-backups
0 2 * * * root /usr/local/bin/backup-db.sh
0 3 * * * root /usr/local/bin/backup-files.sh
```

### Recuperação

```bash
# Recuperar banco de dados
gunzip -c /var/backups/mysql/backup_20241201_020000.sql.gz | mysql -u laravel_user -p laravel_prod

# Recuperar arquivos
tar -xzf /var/backups/files/app_20241201_030000.tar.gz -C /var/www/laravel/
```

## 🔒 Segurança

### Firewall

```bash
# UFW (Ubuntu)
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# iptables (CentOS)
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -P INPUT DROP
```

### Fail2ban

```ini
# /etc/fail2ban/jail.local
[nginx-http-auth]
enabled = true
filter = nginx-http-auth
logpath = /var/log/nginx/error.log
maxretry = 3
bantime = 3600

[nginx-limit-req]
enabled = true
filter = nginx-limit-req
logpath = /var/log/nginx/access.log
maxretry = 10
bantime = 3600
```

### SSL/TLS

```bash
# Let's Encrypt
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d seudominio.com -d www.seudominio.com

# Renovação automática
sudo crontab -e
0 12 * * * /usr/bin/certbot renew --quiet
```

### Configurações de Segurança do Laravel

```php
// config/session.php
'secure' => env('SESSION_SECURE_COOKIE', true),
'http_only' => true,
'same_site' => 'lax',

// config/cors.php
'allowed_origins' => ['https://seudominio.com'],
'allowed_methods' => ['GET', 'POST', 'PUT', 'DELETE'],
'allowed_headers' => ['Content-Type', 'Authorization'],
```

## 🚀 Otimizações de Performance

### Cache

```bash
# Redis para cache
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Cache de consultas
php artisan optimize
```

### CDN

Configure um CDN (Cloudflare, AWS CloudFront) para assets estáticos:

```php
// config/filesystems.php
'disks' => [
    's3' => [
        'driver' => 's3',
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION'),
        'bucket' => env('AWS_BUCKET'),
        'url' => env('AWS_URL'),
        'endpoint' => env('AWS_ENDPOINT'),
        'use_path_style_endpoint' => env('AWS_USE_PATH_STYLE_ENDPOINT', false),
    ],
],
```

### Compressão

```nginx
# Nginx gzip
gzip on;
gzip_vary on;
gzip_min_length 1024;
gzip_proxied expired no-cache no-store private must-revalidate auth;
gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml+rss application/javascript;
```

---

**Última atualização**: $(date +%Y-%m-%d)
