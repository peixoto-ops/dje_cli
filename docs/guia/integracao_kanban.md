# Integração do Kanban e Gerenciamento de Issues

## Visão Geral

Este documento descreve como o projeto utiliza o Kanban e o gerenciamento de issues para organizar e acompanhar o desenvolvimento do PJE CLI Assistant.

## Estrutura do Quadro Kanban

O quadro Kanban está configurado com as seguintes colunas:

- **To Do**: Issues criadas mas ainda não iniciadas
- **In Progress**: Issues que estão sendo trabalhadas
- **Review**: Issues completas aguardando revisão
- **Done**: Issues completas e revisadas

## Política de Ciclo de Vida das Issues

### Criação de Issues
- Toda funcionalidade ou tarefa significativa deve ter uma issue correspondente
- Usar templates de issue (Bug Report ou Feature Request)
- Atribuir labels apropriadas (bug, enhancement, feature, documentation, etc.)
- Associar à milestone adequada (se aplicável)

### Trabalhando em Issues
- Mover a issue para "In Progress" quando começar a trabalhar
- Associar o branch à issue: `feature/#N-assunto` onde N é o número da issue
- Referenciar a issue nos commits: `feat(#N): descrição`
- Atualizar status regularmente no quadro Kanban

### Finalização de Issues
- Abrir Pull Request com referência à issue (ex: `Closes #N` ou `Fixes #N`)
- Mover a issue para "Review" quando o PR estiver aberto
- Após aprovação e merge, mover para "Done"
- Fechar automaticamente a issue via keywords no commit/PR

## Integração com Commits e PRs

### Referências em Commits
- Usar o formato `#N` para referenciar issues nos commits
- Exemplo: `git commit -m "feat: implementar funcionalidade X, resolves #12"`

### Referências em Pull Requests
- Usar keywords para fechar automaticamente issues:
  - `Closes #N`
  - `Fixes #N`
  - `Resolves #N`
- Associar o PR ao projeto Kanban automaticamente

## Política de Fechamento de Issues

### Fechamento Automático
- Issues devem ser fechadas automaticamente via PR com keywords
- O fechamento só deve ocorrer após aprovação do código e testes

### Fechamento Manual
- Somente em casos excepcionais
- Deve incluir explicação clara do motivo
- Atribuir a alguém para verificação final

## Boas Práticas

- Manter o quadro Kanban atualizado diariamente
- Não deixar issues "In Progress" por mais de 2-3 dias sem atualização
- Revisar e limpar issues antigas regularmente
- Usar a wiki para discussões mais longas que não sejam apropriadas para issues
- Rotular issues consistentemente para melhor rastreabilidade

## Integração com Wiki

- Issues podem referenciar páginas da wiki para discussões detalhadas
- Decisões arquiteturais significativas devem ser documentadas na wiki
- Questões técnicas complexas devem ser exploradas na wiki e referenciadas nas issues

## Monitoramento e Relatórios

- Utilizar insights do GitHub para acompanhar:
  - Velocidade de resolução de issues
  - Tempo médio em cada coluna do Kanban
  - Frequência de commits e contribuições
- Revisar métricas semanalmente para melhorar o processo