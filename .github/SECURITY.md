# Política de Segurança

## Versões Suportadas

| Versão | Suporte          |
| ------- | ----------------- |
| 2.x.x   | ✅ Suporte ativo |
| 1.x.x   | ❌ Sem suporte   |
| < 1.0   | ❌ Sem suporte   |

## Reportando uma Vulnerabilidade

Agradecemos que você reporte vulnerabilidades de segurança para nós. Por favor, **NÃO** abra um issue público para vulnerabilidades de segurança.

### Como Reportar

1. **Email de Segurança**: Envie um email para [seu-email@exemplo.com]
2. **Assunto**: Use o prefixo `[SECURITY]` no assunto
3. **Detalhes**: Inclua:
   - Descrição da vulnerabilidade
   - Passos para reproduzir
   - Impacto potencial
   - Sugestões de correção (se houver)

### Processo de Resposta

1. **Confirmação**: Você receberá uma confirmação em 24 horas
2. **Investigações**: Nossa equipe investigará a vulnerabilidade
3. **Atualizações**: Manteremos você informado sobre o progresso
4. **Correção**: Desenvolveremos e testaremos uma correção
5. **Disclosure**: Coordenaremos a divulgação pública

### Timeline Esperado

- **Confirmação**: 24 horas
- **Investigação inicial**: 3-5 dias úteis
- **Correção**: 7-14 dias úteis (dependendo da complexidade)
- **Disclosure**: Coordenado com você

## Boas Práticas de Segurança

### Para Desenvolvedores

- ✅ Sempre execute `make quality` antes de commitar
- ✅ Mantenha dependências atualizadas
- ✅ Use HTTPS para todas as conexões
- ✅ Valide e sanitize todas as entradas
- ✅ Implemente autenticação e autorização adequadas
- ✅ Use variáveis de ambiente para credenciais
- ✅ Monitore logs de segurança

### Para Usuários do Template

- ✅ Mantenha o template atualizado
- ✅ Revise dependências regularmente
- ✅ Configure corretamente variáveis de ambiente
- ✅ Use HTTPS em produção
- ✅ Implemente rate limiting
- ✅ Configure backups seguros
- ✅ Monitore logs de aplicação

## Dependências de Segurança

### Verificações Automáticas

- **Dependabot**: Atualizações semanais de dependências
- **GitHub Security Advisories**: Notificações automáticas
- **PHP Security Checker**: Verificação de vulnerabilidades PHP
- **npm audit**: Verificação de vulnerabilidades Node.js

### Comandos de Verificação

```bash
# Verificar dependências PHP
composer audit

# Verificar dependências Node.js
npm audit

# Verificar qualidade geral
make quality

# Verificar análise estática
make stan
make psalm
```

## Histórico de Vulnerabilidades

### 2025-01-XX
- **Nenhuma vulnerabilidade reportada**

### 2024-12-XX
- **Nenhuma vulnerabilidade reportada**

## Contato

- **Email de Segurança**: [seu-email@exemplo.com]
- **GitHub Issues**: Para bugs não relacionados à segurança
- **Discussions**: Para perguntas e suporte geral

## Agradecimentos

Agradecemos a todos os pesquisadores de segurança que reportam vulnerabilidades de forma responsável. Sua contribuição ajuda a manter nossa comunidade segura.

---

**Última atualização**: $(date +%Y-%m-%d)
