---
layout: default
title: "Convenções de Commit"
nav_order: 4
description: "Padrões para mensagens de commit no projeto PJE CLI Assistant"
permalink: /guia/convencao-commit
parent: "Guias"
tags:
  - git
  - commit
  - convenções
  - desenvolvimento
project: "PJE CLI Assistant"
related:
  - "README.md"
  - "docs/protocolos/documentacao_frontmatter.md"
---

# Convenções de Commit

Este projeto segue o padrão [Conventional Commits](https://www.conventionalcommits.org/pt-br/) para manter um histórico de mudanças consistente e automatizar o versionamento semântico.

## Estrutura do Commit

```
<tipo>[escopo opcional]: <descrição curta>

[corpo opcional, mais detalhado]

[rodapé opcional, para breaking changes ou issues]
```

## Tipos de Commits

| Tipo | Descrição | Exemplo de Uso |
|------|-----------|----------------|
| `feat` | Nova funcionalidade | `feat(ui): adiciona menu de navegação` |
| `fix` | Correção de bug | `fix(api): corrige codificação de espaços` |
| `docs` | Mudanças na documentação | `docs: atualiza README com novas instruções` |
| `style` | Mudanças de formatação | `style: aplica indentação consistente` |
| `refactor` | Mudanças na estrutura do código | `refactor: extrai função de validação` |
| `test` | Adição ou modificação de testes | `test: adiciona testes para função de download` |
| `chore` | Tarefas de manutenção | `chore: atualiza dependências` |
| `build` | Mudanças no sistema de build | `build: adiciona script de empacotamento` |
| `ci` | Mudanças em CI/CD | `ci: atualiza workflow de release` |

## Escopo

O escopo é opcional e define a área do projeto afetada:

- `ui` - Interface do usuário
- `api` - Interação com a API
- `config` - Arquivos de configuração
- `docs` - Documentação
- `multiplataforma` - Compatibilidade entre sistemas

## Exemplos de Commits

### Adicionando funcionalidade
```
feat(config): adiciona verificação de dependências

Implementa verificação para garantir que curl e jq estejam
disponíveis antes de executar o script principal.
```

### Corrigindo bug
```
fix(multiplataforma): corrige abertura de navegador no Windows

Substitui uso de xdg-open por comando apropriado para cada sistema
operacional, detectando automaticamente o ambiente.
```

### Mudança significativa (Breaking Change)
```
refactor(ui): reestrutura menu principal

BREAKING CHANGE: Muda a estrutura de navegação do script,
requerindo que os usuários se adaptem à nova interface.

Substitui o menu sequencial por um sistema de navegação
baseado em seleção de opções numéricas.
```

## Boas Práticas

1. **Use o imperativo no título**: "Adiciona" e não "Adicionando" ou "Adicionado"
2. **Mantenha o título conciso**: Menos de 50 caracteres quando possível
3. **Use o corpo para detalhes**: Explique o porquê da mudança
4. **Inclua referências a issues quando aplicável**
5. **Use caixa baixa para o corpo e descrição**
6. **Use caixa alta para o tipo de commit**

## Templates de Commit

Você pode configurar um template global para commits:

```bash
git config --global commit.template ~/.gitmessage.txt
```

Conteúdo recomendado para `~/.gitmessage.txt`:
```
<tipo>(<escopo>): 

[Explique o porquê da mudança aqui]

[Adicione mais detalhes, se necessário]
```