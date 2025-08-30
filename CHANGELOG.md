# 📋 Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

## [2.1.0] - 2025-08-30

### 🚀 Psalm de Volta + Melhorias

#### ✨ Novidades
- **Psalm 7.x** - De volta com suporte completo para PHP 8.4
- **PHPStan 2.x** - Atualizado com Larastan 3.x para Laravel 12
- **Análise Estática Dual** - PHPStan + Psalm para máxima cobertura
- **Script create-project.sh** - Cria novos projetos a partir do template
- **Duas Abordagens de Uso** - Template como base ou instalação direta

#### 🔧 Mudanças Técnicas
- PHPStan atualizado da v1.x para v2.x
- **Larastan**: Migrado de `nunomaduro/larastan` (abandonado) para `larastan/larastan` (ativo)
- **Psalm**: Versão estável 6.13 (compatível PHP 8.4) em vez de 7.x-dev
- Makefile adicionado comando `psalm` e `create-project`
- Configuração psalm.xml otimizada
- **LICENSE não copiada** - Permite projetos comerciais com licenças próprias
- **Stability**: Mudado de `dev` para `stable` - apenas versões maduras
- **CI/CD**: Corrigido GitHub Actions para usar package-lock.json e ferramentas Composer

#### 📚 Documentação
- README atualizado com duas abordagens de uso
- QUICKSTART com instruções claras
- .cursorrules atualizado com Psalm
- Documentação complementar sobre Psalm

#### 🐛 Correções
- Compatibilidade entre Psalm e PHP 8.4 resolvida
- Dependências conflitantes corrigidas
- Scripts de setup melhorados

---

## [2.0.0] - 2025-08-30

### 🚀 Atualização para Laravel 12

#### ✨ Novidades
- **Laravel 12** - Framework mais recente e estável
- **PHP 8.4** - Suporte à versão mais recente do PHP
- **Melhorias de Performance** - Otimizações específicas do Laravel 12
- **Novos Recursos** - Aproveitamento das funcionalidades mais recentes

#### 🔧 Mudanças Técnicas
- Atualizado `composer.json` para Laravel 12
- Ajustadas configurações para compatibilidade
- Atualizada documentação para Laravel 12
- Melhorados scripts de setup e deploy

#### 📚 Documentação
- README atualizado para Laravel 12
- QUICKSTART atualizado
- Guias de desenvolvimento e deploy atualizados
- Changelog criado

#### 🐳 Docker
- Configurações Docker otimizadas para Laravel 12
- PHP 8.4 como versão padrão
- Extensões PHP atualizadas

#### 🧪 Testes e Qualidade
- PHPStan configurado para Laravel 12
- Psalm 7.x com suporte para PHP 8.4
- Laravel Pint otimizado
- PSR-12 mantido como padrão

#### 🚀 CI/CD
- GitHub Actions atualizado
- Workflows otimizados para Laravel 12
- Testes de compatibilidade

---

## [1.0.0] - 2024-11-30

### 🎉 Lançamento Inicial

#### ✨ Características
- **Laravel 11** - Framework estável
- **PHP 8.4** - Suporte à versão mais recente
- **Docker + Laravel Sail** - Ambiente de desenvolvimento
- **Análise Estática** - PHPStan + Psalm
- **Formatação de Código** - Laravel Pint + PHP CS Fixer
- **Testes** - PHPUnit configurado
- **Qualidade de Código** - Scripts automatizados

#### 🏗️ Estrutura
- Template completo para Laravel
- Configurações otimizadas
- Scripts de setup e deploy
- Documentação abrangente
- CI/CD pipeline
- Configurações Docker

---

## 📝 Formato do Changelog

Este projeto segue o [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/).

### Tipos de Mudanças
- **✨ Adicionado** - Novas funcionalidades
- **🔧 Alterado** - Mudanças em funcionalidades existentes
- **🐛 Corrigido** - Correções de bugs
- **🚀 Melhorado** - Melhorias de performance
- **📚 Documentação** - Atualizações na documentação
- **🧪 Testes** - Mudanças relacionadas a testes
- **🐳 Docker** - Mudanças relacionadas ao Docker
- **🚀 CI/CD** - Mudanças relacionadas ao pipeline

---

**Para mais detalhes sobre as mudanças, consulte os commits do Git.**
