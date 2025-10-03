# Política de Gerenciamento de Branches

## Modelo de Branching: Git Flow

Este projeto segue o modelo de branching Git Flow com as seguintes convenções:

### Branches Principais

- `main`: Contém o código de produção estável. Apenas releases passam por esta branch.
- `develop`: Branch de desenvolvimento principal. Recebe todas as features completadas e testadas.

### Branches de Apoio

- `feature/*`: Branches para desenvolvimento de novas funcionalidades.
  - Criada a partir de: `develop`
  - Merged de volta em: `develop`
  - Convenção de nomenclatura: `feature/nome-da-funcionalidade`

- `release/*`: Branches para preparação de releases.
  - Criada a partir de: `develop`
  - Merged de volta em: `develop` e `main`
  - Convenção de nomenclatura: `release/vX.Y.Z`

- `hotfix/*`: Branches para correções críticas em produção.
  - Criada a partir de: `main`
  - Merged de volta em: `develop` e `main`
  - Convenção de nomenclatura: `hotfix/vX.Y.Z`

### Política de Commits

- Commits pequenos e atômicos
- Mensagens de commit em português usando Conventional Commits
- Commits frequentes para evitar perda de trabalho
- Não fazer commits diretos em `main` ou `develop`

### Política de Pull Requests

- Toda feature/hotfix deve ter um Pull Request
- Pelo menos uma revisão aprovada antes do merge
- CI deve estar passando
- Pull Request deve estar em dia com a branch de destino

### Proteção de Branches

- `main` e `develop`: Protegidas com aprovação obrigatória
- Não permitir force push
- Não permitir delete
- Exigir status checks antes do merge