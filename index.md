---
layout: default
title: Home
nav_order: 1
description: "PJE CLI Assistant - Um assistente de linha de comando para o PJE"
permalink: /
---

# PJE CLI Assistant

{: .fs-9 .fw-700 .mb-6 }

> Um assistente de linha de comando em Bash para interagir com a API de Comunicação do Processo Judicial Eletrônico (PJE) do Brasil.

{: .fs-6 .fw-300 }

---

## Visão Geral

O PJE CLI Assistant é uma ferramenta poderosa que permite que advogados consultem e gerenciem seus processos judiciais diretamente do terminal, oferecendo uma alternativa eficiente à interface web do PJE.

### Características

- **Consulta de processos**: Busque todos os processos associados ao seu OAB
- **Histórico de andamentos**: Visualize a linha do tempo de cada processo
- **Ações rápidas**: Abra documentos no navegador ou faça download em PDF
- **Multiplataforma**: Compatível com Linux, macOS e Windows
- **Versionamento semântico**: Releases automatizados com CI/CD
- **Documentação estruturada**: Frontmatter YAML para metadados de documentos

### Começando

1. Clone o repositório:
   ```bash
   git clone https://github.com/peixoto-ops/dje_cli.git
   ```

2. Instale as dependências:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install curl jq
   ```

3. Configure suas credenciais:
   ```bash
   cp src/config/pje.conf.example src/config/pje.conf
   # Edite src/config/pje.conf com seus dados
   ```

4. Execute o script:
   ```bash
   ./src/pje_cli.sh
   ```

## Documentação

{% assign docs = site.docs | group_by: "category" %}

<ul>
{% for group in docs %}
  <li>{{ group.name }}
    <ul>
    {% for item in group.items %}
      <li><a href="{{ item.url | relative_url }}">{{ item.title }}</a></li>
    {% endfor %}
    </ul>
  </li>
{% endfor %}
</ul>

## Contribuindo

Leia nosso [guia de contribuição](./docs/guia/contribuicao.md) para detalhes sobre como:

- Configurar seu ambiente de desenvolvimento
- Seguir nossas convenções de código e commit
- Submeter Pull Requests
- Reportar problemas

## Licença

Este projeto está licenciado sob a [MIT License](./LICENSE).

## Contato

Luiz Peixoto - [luizpeixoto@duckgo.com](mailto:luizpeixoto@duckgo.com)