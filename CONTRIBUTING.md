# 🤝 Guia de Contribuição

Obrigado por considerar contribuir para o Template Laravel! Este documento fornece diretrizes para contribuições.

## 📋 Índice

- [Como Contribuir](#como-contribuir)
- [Configurando o Ambiente](#configurando-o-ambiente)
- [Padrões de Código](#padrões-de-código)
- [Processo de Pull Request](#processo-de-pull-request)
- [Diretrizes de Commit](#diretrizes-de-commit)
- [Reportando Bugs](#reportando-bugs)
- [Solicitando Funcionalidades](#solicitando-funcionalidades)
- [Perguntas Frequentes](#perguntas-frequentes)

## 🚀 Como Contribuir

### Tipos de Contribuições

- 🐛 **Bug Fixes**: Correções de problemas existentes
- ✨ **Novas Funcionalidades**: Adição de recursos úteis
- 📚 **Documentação**: Melhorias na documentação
- 🧪 **Testes**: Adição ou melhoria de testes
- 🔧 **Ferramentas**: Melhorias nas ferramentas de qualidade
- 🎨 **Refatoração**: Melhorias na estrutura do código

### Antes de Contribuir

1. **Verifique se já existe** um issue ou discussão sobre sua ideia
2. **Leia a documentação** existente para entender o projeto
3. **Teste localmente** antes de submeter
4. **Siga os padrões** estabelecidos do projeto

## 🛠️ Configurando o Ambiente

### Pré-requisitos

- **PHP**: 8.4+
- **Composer**: 2.6+
- **Docker**: 24.0+ (opcional)
- **Git**: 2.30+

### Setup Local

```bash
# Clone o repositório
git clone https://github.com/rogash/template.git
cd template

# Instale as dependências
composer install

# Configure o ambiente
cp .env.example .env
php artisan key:generate

# Execute as verificações de qualidade
make quality

# Execute os testes
make test
```

### Scripts Úteis

```bash
# Verificação completa de qualidade
make quality

# Análise estática individual
make stan          # PHPStan
make psalm         # Psalm

# Formatação de código
make pint          # Laravel Pint
make cs-check      # Verificar PSR-12
make cs-fix        # Corrigir PSR-12

# Testes
make test          # Executar testes
make test-coverage # Testes com cobertura
```

## 📝 Padrões de Código

### PHP (Laravel)

- **Padrão**: PSR-12 estritamente
- **Indentação**: 4 espaços
- **Chaves**: Na mesma linha para classes e métodos
- **Tipagem**: Sempre usar type hints e return types
- **Propriedades**: Usar `readonly` quando possível
- **Construtor**: Usar constructor property promotion

### Exemplo de Código

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
}
```

### Arquivos de Configuração

- **YAML/NEON**: 2 espaços de indentação
- **XML**: 2 espaços de indentação
- **JSON**: 2 espaços de indentação
- **Markdown**: Sem indentação extra

## 🔄 Processo de Pull Request

### 1. Preparação

- [ ] Fork o repositório
- [ ] Crie uma branch para sua feature
- [ ] Execute `make quality` e `make test`
- [ ] Certifique-se de que todos os testes passam

### 2. Desenvolvimento

- [ ] Implemente suas mudanças
- [ ] Adicione testes para novas funcionalidades
- [ ] Atualize a documentação conforme necessário
- [ ] Execute verificações de qualidade novamente

### 3. Submissão

- [ ] Commit suas mudanças seguindo as diretrizes
- [ ] Push para sua branch
- [ ] Abra um Pull Request
- [ ] Preencha o template do PR completamente

### 4. Revisão

- [ ] Responda aos comentários da revisão
- [ ] Faça as alterações solicitadas
- [ ] Mantenha o histórico de commits limpo

## 📝 Diretrizes de Commit

### Formato

```
tipo(escopo): descrição curta

Descrição mais detalhada se necessário

- Mudança 1
- Mudança 2
- Mudança 3

Resolve #123
```

### Tipos de Commit

- **feat**: Nova funcionalidade
- **fix**: Correção de bug
- **docs**: Documentação
- **style**: Formatação (não afeta código)
- **refactor**: Refatoração de código
- **test**: Adição ou correção de testes
- **chore**: Tarefas de manutenção

### Exemplos

```bash
# Nova funcionalidade
git commit -m "feat: adiciona suporte ao PHP 8.4

- Atualiza dependências para PHP 8.4
- Adiciona testes de compatibilidade
- Atualiza documentação"

# Correção de bug
git commit -m "fix: corrige problema de memória no PHPStan

- Aumenta limite de memória para 4GB
- Otimiza configuração de análise
- Adiciona fallback para sistemas com pouca RAM"

# Documentação
git commit -m "docs: atualiza README com instruções de instalação

- Adiciona seção de pré-requisitos
- Inclui comandos de setup
- Melhora formatação e organização"
```

## 🐛 Reportando Bugs

### Antes de Reportar

1. **Verifique se já foi reportado** - Procure nos issues existentes
2. **Teste com a versão mais recente** - O bug pode já ter sido corrigido
3. **Reproduza o problema** - Certifique-se de que é reproduzível
4. **Colete informações** - Logs, screenshots, passos para reproduzir

### Template de Bug Report

Use o template `🐛 Reportar Bug` ao criar um issue:

- **Descrição clara** do problema
- **Passos para reproduzir** detalhados
- **Comportamento esperado** vs. **comportamento atual**
- **Informações do sistema** (OS, PHP, Laravel, etc.)
- **Logs de erro** se disponíveis

## ✨ Solicitando Funcionalidades

### Antes de Solicitar

1. **Verifique se já foi solicitado** - Procure nas discussões existentes
2. **Pense no caso de uso** - Como isso beneficiaria a comunidade?
3. **Considere alternativas** - Existe uma solução já disponível?
4. **Pesquise** - Outros projetos similares já implementaram isso?

### Template de Feature Request

Use o template `✨ Solicitar Funcionalidade` ao criar um issue:

- **Descrição clara** da funcionalidade
- **Problema que resolve** - Por que isso é necessário?
- **Casos de uso** específicos
- **Impacto técnico** estimado
- **Prioridade** da funcionalidade

## ❓ Perguntas Frequentes

### Q: Posso contribuir mesmo sendo iniciante?

**A**: Sim! Contribuições de todos os níveis são bem-vindas. Comece com:
- Documentação
- Testes
- Issues de "good first issue"
- Melhorias pequenas

### Q: Como sei se minha contribuição será aceita?

**A**: Contribuições são aceitas se:
- Seguem os padrões do projeto
- Resolvem um problema real
- Não quebram funcionalidades existentes
- Incluem testes adequados

### Q: Posso contribuir com ferramentas de frontend?

**A**: O template foca em qualidade PHP, mas melhorias nas ferramentas de desenvolvimento são bem-vindas.

### Q: Como faço para ser um mantenedor?

**A**: Mantenedores são escolhidos com base em:
- Contribuições consistentes e de qualidade
- Conhecimento técnico do projeto
- Disponibilidade para revisar PRs
- Comunicação efetiva com a comunidade

## 📞 Contato

- **Issues**: Para bugs e funcionalidades
- **Discussions**: Para perguntas e discussões
- **Email**: [seu-email@exemplo.com]
- **GitHub**: [@rogash](https://github.com/rogash)

## 🙏 Agradecimentos

Agradecemos a todos os contribuidores que ajudam a tornar este template melhor para a comunidade Laravel!

---

**Juntos construímos ferramentas incríveis! 🚀**

**Última atualização**: $(date +%Y-%m-%d)
