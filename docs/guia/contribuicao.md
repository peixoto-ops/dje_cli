---
title: "Guia de Contribuição"
date_created: "2024-05-26"
last_modified: "2024-05-26"
tags:
  - contribuição
  - desenvolvimento
  - git
  - github
project: "PJE CLI Assistant"
related:
  - "README.md"
  - "docs/guia/convencao_commit.md"
---

# Guia de Contribuição

Agradecemos pelo seu interesse em contribuir para o PJE CLI Assistant! Este documento fornece diretrizes para contribuir com o projeto de forma eficaz.

## Como Contribuir

### 1. Reportar Problemas

Antes de reportar um problema:

- Verifique se o problema já foi reportado em [Issues](https://github.com/seu-usuario/dje_cli/issues)
- Execute uma pesquisa detalhada com palavras-chave relevantes

Ao criar um reporte de problema:

- Forneça um título claro e descritivo
- Descreva o problema com detalhes
- Inclua passos para reproduzir o problema
- Adicione informações sobre o sistema (SO, versão do bash, etc.)

### 2. Solicitar Funcionalidades

Para solicitar novas funcionalidades:

- Verifique se a funcionalidade já foi solicitada
- Descreva claramente a funcionalidade desejada
- Explique por que essa funcionalidade seria útil

### 3. Contribuir com Código

#### Setup do Ambiente de Desenvolvimento

1. Fork o repositório
2. Clone seu fork:
   ```bash
   git clone https://github.com/seu-usuario/dje_cli.git
   cd dje_cli
   ```
3. Instale as dependências:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install curl jq bash
   
   # macOS
   brew install curl jq
   ```

#### Processo de Contribuição

1. Crie uma branch para sua funcionalidade:
   ```bash
   git checkout -b feature/nova-funcionalidade
   ```

2. Siga as convenções de commit estabelecidas:
   - Use commits convencionais
   - Escreva mensagens de commit claras e descritivas
   - Exemplo: `feat(ui): adiciona menu de navegação intuitivo`

3. Teste suas mudanças localmente

4. Faça commit das alterações:
   ```bash
   git add .
   git commit -m "feat: adiciona nova funcionalidade"
   ```

5. Envie sua branch:
   ```bash
   git push origin feature/nova-funcionalidade
   ```

6. Abra um Pull Request com uma descrição detalhada

## Convenções de Código

### Bash Scripting

- Use `#!/usr/bin/env bash` como shebang
- Siga convenções de nomenclatura consistentes
- Use funções para organizar o código logicamente
- Inclua comentários claros para código complexo
- Implemente tratamento de erros apropriado

### Conventional Commits

Este projeto segue o padrão Conventional Commits:

- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Mudanças na documentação
- `refactor`: Mudanças na estrutura do código
- `test`: Adição ou modificação de testes
- `chore`: Tarefas de manutenção
- `build`: Mudanças no sistema de build
- `ci`: Mudanças em CI/CD

## Estrutura de Pastas

- `src/`: Código-fonte principal
- `docs/`: Documentação do projeto
- `scripts/`: Scripts auxiliares
- `tests/`: Casos de teste
- `.github/workflows/`: Workflows de CI/CD

## Padrões de Documentação

### Frontmatter YAML

Todos os arquivos de documentação devem incluir frontmatter YAML:

```yaml
---
title: "Título do Documento"
date_created: "2024-05-26"
last_modified: "2024-05-26"
tags:
  - tag1
  - tag2
project: "PJE CLI Assistant"
related:
  - "caminho/do/arquivo/relacionado.md"
---
```

## Processo de Revisão

Todos os Pull Requests passarão por:

- Revisão de código por mantenedores
- Verificação de conformidade com convenções
- Testes de funcionalidade (quando aplicável)
- Verificação de documentação

## Código de Conduta

Este projeto adota um código de conduta baseado nos princípios de respeito, inclusão e colaboração. Ao contribuir, você concorda em seguir esses princípios.

## Agradecimento

Agradecemos a todos que contribuem para este projeto, seja reportando bugs, sugerindo funcionalidades, contribuindo com código ou melhorando a documentação.