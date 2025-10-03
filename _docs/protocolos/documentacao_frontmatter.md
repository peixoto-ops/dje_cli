---
layout: default
title: "Protocolo de Documentação com Frontmatter"
nav_order: 7
description: "Protocolo de uso de frontmatter YAML para organizar a documentação"
permalink: /protocolos/frontmatter
parent: "Protocolos"
tags:
  - documentação
  - frontmatter
  - protocolo
  - projeto
project: "PJE CLI Assistant"
related:
  - "docs/api/orienta_documenta_api.md"
  - "docs/specs/spec_kit.md"
---

# Protocolo de Documentação com Frontmatter

## Objetivo

Este documento estabelece o protocolo de uso de frontmatter YAML para organizar e indexar a documentação do projeto PJE CLI Assistant. O frontmatter permite que os arquivos de documentação sejam tratados como objetos de dados, facilitando a busca, indexação e organização automática do conhecimento.

## Estrutura Padrão do Frontmatter

Todo arquivo de documentação deve conter um bloco de frontmatter YAML no início do arquivo, delimitado por três traços (`---`):

```yaml
---
title: "Título do Documento"
date_created: "YYYY-MM-DD"
last_modified: "YYYY-MM-DD"
tags:
  - tag1
  - tag2
  - tag3
project: "PJE CLI Assistant"
related:
  - "caminho/do/arquivo/relacionado.md"
  - "outro/arquivo.md"
---
```

## Campos Obrigatórios

- `title`: Título claro e descritivo do conteúdo do documento
- `date_created`: Data de criação no formato YYYY-MM-DD
- `project`: Nome do projeto, sempre "PJE CLI Assistant"

## Campos Opcionais

- `last_modified`: Data da última modificação (atualizar sempre que alterar o conteúdo)
- `tags`: Lista de tags para categorização e busca (mínimo 1 tag)
- `related`: Lista de arquivos relacionados para criar uma rede de conhecimento

## Boas Práticas

1. **Tags específicas**: Use tags específicas que ajudem na busca (ex: `api`, `bash`, `windows`, `multiplataforma`)
2. **Relacionamentos**: Sempre que possível, inclua arquivos relacionados para criar conexões lógicas
3. **Atualização**: Mantenha `last_modified` atualizado em cada alteração
4. **Consistência**: Use a mesma convenção para nomes de tags em todos os documentos

## Comando para Inspeção Rápida

Para inspecionar rapidamente os frontmatters de todos os arquivos de documentação:

```bash
find docs/ -name "*.md" -exec sh -c 'echo "=== {} ==="; head -n 15 "$1" | grep -A 12 -E "^---|^title:|^date_|^tags:|^project:"' _ {} \;
```

Este comando exibe os frontmatters de todos os arquivos Markdown na pasta docs/, facilitando a verificação da consistência dos metadados.