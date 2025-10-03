# Política de Commits Periódicos e Rastreabilidade

## Visão Geral

Este documento estabelece as práticas de commits para garantir rastreabilidade, prevenção de perda de trabalho e histórico de desenvolvimento limpo no projeto PJE CLI Assistant.

## Política de Commits Periódicos

### Princípios Básicos

- **Commits frequentes**: Faça commits regularmente para evitar perda de trabalho
- **Commits atômicos**: Cada commit deve representar uma única mudança lógica
- **Mensagens claras**: Use mensagens descritivas e padronizadas
- **Trabalho funcional**: Cada commit deve manter o projeto em um estado funcional (quando possível)

### Frequência de Commits

- **Work In Progress (WIP)**: Commits intermediários são permitidos e encorajados
- **Limite de tempo**: Não trabalhar mais de 1-2 horas sem fazer um commit
- **Pontos de verificação**: Commits em pontos lógicos de conclusão de tarefas

### Mensagens de Commit

Este projeto segue o padrão [Conventional Commits](https://www.conventionalcommits.org/pt-br/):

```
<tipo>[escopo opcional]: <descrição curta>

[corpo opcional, mais detalhado]

[rodapé opcional, para breaking changes ou issues]
```

#### Tipos de Commits

- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Mudanças na documentação
- `style`: Mudanças de formatação (sem alterar lógica)
- `refactor`: Refatoração de código (sem alterar funcionalidade)
- `test`: Adição ou modificação de testes
- `chore`: Tarefas de manutenção
- `build`: Alterações no sistema de build
- `ci`: Alterações em CI/CD
- `perf`: Melhorias de performance
- `revert`: Reversão de commits anteriores

#### Escopo

Quando aplicável, inclua o escopo entre parênteses após o tipo:

```
feat(api): melhora a autenticação com o PJE
fix(ui): corrige bug na navegação de processos
docs(readme): atualiza instruções de instalação
```

## Rastreabilidade

### Referências a Issues

- Referenciar issues nos commits: `git commit -m "feat: implementar login, closes #12"`
- Usar keywords para fechamento automático:
  - `closes #N`
  - `fixes #N`
  - `resolves #N`

### Commits WIP

Para commits intermediários (Work In Progress) que ainda não estão prontos para serem mesclados:

```
WIP: implementando nova funcionalidade de busca
```

Esses commits podem ser posteriormente combinados com `git rebase -i`.

### Commits de Revert/Reparo

- Para commits que corrigem outros commits: `revert: "feat: adicionar nova funcionalidade"`
- Para correções rápidas: `fixup!` (usando `git commit --fixup`)

## Política de Branches e Commits

### Antes de Mudar de Branch

1. **Salvar trabalho intermediário**:
   - Opção A: Fazer commit com mensagem WIP
   - Opção B: Usar `git stash` para salvar alterações temporariamente

2. **Verificar status**:
   - Executar `git status` para confirmar o estado
   - Verificar quais arquivos serão commitados

### Política de Backup

- O script `scripts/backup.sh` (a ser implementado) deve ser executado periodicamente
- Usar `git add . && git commit -m "backup: estado de trabalho"` para commits de segurança

## Pre-commit Hooks

### Hooks Locais Recomendados

1. **Validação de sintaxe** para arquivos Bash
2. **Verificação de tamanho** de commits (não exceder limite razoável)
3. **Validação de mensagens** de commit (padrão Conventional Commits)

### Implementação de Hook Básico

Criar `.git/hooks/pre-commit`:

```bash
#!/bin/bash
# Verifica sintaxe dos arquivos Bash modificados
for file in $(git diff --cached --name-only --diff-filter=ACM | grep '\.sh$'); do
    bash -n "$file" || exit 1
done
```

## Boas Práticas Adicionais

### Commits Significados

- Usar `git add -p` para adicionar mudanças parciais quando necessário
- Evitar commits muito grandes (mais de 100 linhas, em geral)
- Manter os commits com mudanças lógicas coesas

### Desfazendo Commits

1. **Último commit local**: `git reset --soft HEAD~1`
2. **Múltiplos commits locais**: `git reset --soft HEAD~n`
3. **Modificar último commit**: `git commit --amend`
4. **Combinar commits**: `git rebase -i HEAD~n`

### Tratamento de Branches Perdidas

- Usar `git reflog` para encontrar commits perdidos
- Criar branch temporário a partir de commit específico: `git branch temp_branch <commit_hash>`

## Integração com Processo de Desenvolvimento

- Commits devem estar alinhados com as issues no quadro Kanban
- Cada PR deve conter commits que fecham issues específicas
- Histórico de commits deve servir como documentação do processo de desenvolvimento
- Commits devem refletir o progresso real do desenvolvimento e não apenas o estado final

## Revisão de Commits

- Revisores devem verificar a qualidade e granularidade dos commits
- Commits mal estruturados devem ser revisados antes do merge
- Uso de `Squash and merge` quando aprimorar o histórico for necessário