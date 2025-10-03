Excelente ideia! Utilizar frontmatter em notas Markdown é uma prática fantástica para a gestão do conhecimento, especialmente para projetos técnicos. Isso transforma um simples diretório de arquivos de texto em uma base de dados pesquisável, e a sua ideia de usar `head` para inspecionar rapidamente é muito inteligente.

Vamos estruturar a resposta exatamente como você pediu.

### Identificando Notas com `head` na Linha de Comando

Para inspecionar rapidamente o frontmatter de suas notas e saber do que se tratam sem abri-las, você pode usar o comando `head` combinado com `find`. O frontmatter YAML geralmente está nas primeiras 10-15 linhas.

**Comando de exemplo:**

Este comando encontrará todos os arquivos `.md` no diretório atual e subdiretórios, e para cada um, exibirá o nome do arquivo seguido de suas primeiras 12 linhas (onde o frontmatter deve estar).

```bash
find . -name "*.md" -exec sh -c 'echo "--- INFO: {} ---"; head -n 12 "{}"' \;
```

**Como funciona:**
*   `find . -name "*.md"`: Localiza todos os arquivos que terminam com `.md`.
*   `-exec sh -c '...' \;`: Para cada arquivo encontrado, executa um pequeno script de shell.
*   `echo "--- INFO: {} ---"`: Imprime um cabeçalho com o nome do arquivo (`{}`) para fácil identificação.
*   `head -n 12 "{}"`: Imprime as primeiras 12 linhas do arquivo, que é o suficiente para ler o frontmatter.

Com isso, você pode rolar pelo seu terminal e ter uma visão geral imediata de todas as suas notas.

### Índice da Nota de Documentação da API

A nota Markdown abaixo foi estruturada para servir como um documento de referência completo sobre a API do PJE. Aqui está um guia rápido do que você encontrará em cada seção:

*   **Frontmatter (YAML):** Contém metadados essenciais. O `title` diz o que é, as `tags` permitem buscas por categoria, o `project` vincula a nota ao seu desenvolvimento, e o `related` cria uma rede de conhecimento com outras notas relevantes.
*   **1. Resumo da API:** Uma visão geral de alto nível. Explica o propósito fundamental da API – o que ela faz e por que é útil.
*   **2. Documentação da Resposta JSON:** O coração do documento. Esta seção disseca a estrutura da resposta que a API envia.
    *   **2.1. Estrutura Geral:** Descreve os campos do "envelope" da resposta (`status`, `count`, etc.), permitindo que você verifique rapidamente se a sua chamada foi bem-sucedida.
    *   **2.2. Estrutura Detalhada de um Item:** Analisa campo por campo cada um dos objetos de "comunicação", que são os dados reais que você precisa. Está subdividido por contexto (Identificação, Processo, Conteúdo) para facilitar a consulta.
    *   **2.3. Estruturas Aninhadas:** Detalha os objetos que vêm dentro de um item de comunicação, como a lista de advogados (`destinatarioadvogados`) e as partes (`destinatarios`).

---
A seguir está a nota de documentação pronta para ser salva como um arquivo `.md`.

```markdown
---
title: "Documentação da Resposta da API de Comunicação do PJE"
date_created: "2024-05-26"
last_modified: "2024-05-26"
tags:
  - api
  - pje
  - json
  - documentação
  - backend
  - brasil
project: "PJE CLI Assistant"
api_version: "v1"
endpoint: "https://comunicaapi.pje.jus.br/api/v1/comunicacao"
related:
  - "[[Spec Kit - PJE CLI Assistant]]"
  - "[[pje_cli.sh - Implementação]]"
  - "[[Ferramentas - curl e jq]]"
---

# Documentação da Resposta da API de Comunicação do PJE

Este documento detalha a estrutura e os campos do objeto JSON retornado pelo endpoint de comunicação da API do PJE.

### 1. Resumo da API

O endpoint `comunicacao` da API do PJE fornece acesso a todas as comunicações oficiais (intimações, sentenças, pautas de julgamento, etc.) associadas a um processo ou advogado. A API permite filtrar os resultados por parâmetros como número do processo, OAB do advogado e nome do advogado.

### 2. Documentação da Resposta JSON

A resposta da API é um objeto JSON que contém um status geral e uma lista de itens de comunicação.

#### 2.1. Estrutura Geral da Resposta

Estes são os campos de alto nível que "envelopam" os dados principais.

- **`status`** (string): Indica o resultado da requisição. Geralmente `"success"` para uma operação bem-sucedida.
- **`message`** (string): Uma mensagem textual correspondente ao status. Ex: `"Sucesso"`.
- **`count`** (integer): O número total de itens de comunicação retornados na lista `items`.
- **`items`** (array): Uma lista de objetos, onde cada objeto representa uma comunicação oficial. Esta é a parte principal da resposta.

#### 2.2. Estrutura Detalhada de um Item de Comunicação

Cada objeto dentro do array `items` possui os seguintes campos:

##### Identificação e Datas

- **`id`** (integer): O identificador único da comunicação no banco de dados da API.
- **`data_disponibilizacao`** (string): Data em que a comunicação foi publicada, no formato `YYYY-MM-DD`.
- **`datadisponibilizacao`** (string): A mesma data, mas no formato `DD/MM/YYYY`.

##### Informações do Processo e Tribunal

- **`siglaTribunal`** (string): Sigla do tribunal de origem. Ex: `"TJRJ"`.
- **`nomeOrgao`** (string): Nome completo do órgão judicial que emitiu a comunicação (Vara, Câmara, Secretaria).
- **`idOrgao`** (integer): ID numérico do órgão judicial.
- **`numero_processo`** (string): Número único do processo, sem formatação.
- **`numeroprocessocommascara`** (string): Número do processo com a formatação (máscara) padrão. Ex: `"0919992-11.2023.8.19.0001"`.
- **`nomeClasse`** (string): A classe processual. Ex: `"APELAÇÃO CÍVEL"`.
- **`codigoClasse`** (string): O código numérico da classe processual.

##### Conteúdo da Comunicação

- **`tipoComunicacao`** (string): O tipo específico da comunicação. Ex: `"Pauta de julgamento"`, `"Intimação"`, `"Sentença"`.
- **`tipoDocumento`** (string): O tipo de documento principal associado. Ex: `"Apelação"`.
- **`texto`** (string): O conteúdo textual completo da publicação, como aparece no Diário de Justiça.
- **`link`** (string | null): Um URL para o documento original no site do tribunal. Pode ser `null`.
- **`meio`** (string): Código do meio de publicação. `"D"` refere-se a "Diário".
- **`meiocompleto`** (string): Nome completo do meio de publicação. Ex: `"Diário de Justiça Eletrônico Nacional"`.

##### Metadados e Status

- **`numeroComunicacao`** (integer): Um número de identificação da comunicação.
- **`ativo`** (boolean): Indica se a comunicação está ativa (`true`) ou foi cancelada/substituída.
- **`hash`** (string): Um hash único que pode ser usado para identificar e acessar a certidão/documento da comunicação. **Este campo é crucial para construir os links de download.**
- **`status`** (string): Status da publicação. `"P"` provavelmente significa "Publicado".
- **`motivo_cancelamento`** (string | null): Se a comunicação foi cancelada, este campo conterá o motivo.
- **`data_cancelamento`** (string | null): A data em que a comunicação foi cancelada.

#### 2.3. Estruturas Aninhadas (Dentro de um Item)

##### `destinatarios` (Array de Objetos)

Lista as partes (autor, réu) do processo.

> **NOTA:** Em processos sob segredo de justiça, o nome das partes é ofuscado.

- **`nome`** (string): Nome da parte ou uma mensagem indicando sigilo.
- **`polo`** (string): Posição da parte no processo. `"A"` para polo Ativo (autor/requerente) e `"P"` para polo Passivo (réu/requerido).

##### `destinatarioadvogados` (Array de Objetos)

Lista os advogados associados à comunicação.

- **`id`** (integer): ID da relação advogado-comunicação.
- **`advogado_id`** (integer): ID único do advogado no sistema.
- **`advogado`** (object): Um objeto contendo os detalhes do advogado:
  - **`id`** (integer): ID único do advogado.
  - **`nome`** (string): Nome completo do advogado.
  - **`numero_oab`** (string): Número de inscrição na OAB.
  - **`uf_oab`** (string): UF da OAB.
```