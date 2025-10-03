
---
layout: default
title: "Especificação Técnica"
nav_order: 6
description: "Especificação técnica completa do PJE CLI Assistant"
permalink: /specs/especificacao
parent: "Especificações"
tags:
  - especificação
  - projeto
  - desenvolvimento
  - bash
project: "PJE CLI Assistant"
---

# Especificação Técnica: PJE CLI Assistant v1.0

**Para:** Agente de Codificação (Qwen-cli)
**De:** [Seu Nome]
**Assunto:** Especificação técnica para a criação de um script Bash de automação de consulta ao PJE.

#### **1. Visão Geral e Objetivo do Projeto**

Desenvolver um script de linha de comando em Bash chamado `pje_cli.sh`. Este script servirá como um assistente para advogados consultarem e gerenciarem seus processos judiciais através da API de Comunicação do PJE. O script deve ser interativo, robusto e fácil de usar.

#### **2. Requisitos Funcionais (Features)**

1.  **Configuração Externa:** Os dados do advogado (Nome, OAB, UF) devem ser lidos de um arquivo `pje.conf`.
2.  **Consulta de Processos:** O script deve buscar e listar todos os processos únicos associados ao advogado.
3.  **Seleção de Processo:** O usuário deve poder selecionar um processo da lista para ver mais detalhes.
4.  **Visualização de Histórico:** O script deve exibir todas as comunicações (andamentos) de um processo selecionado.
5.  **Menu de Ações:** Para cada comunicação, o usuário deve ter as opções de:
    *   Abrir o documento em um navegador web.
    *   Baixar o documento (PDF) para o disco local.

#### **3. Requisitos Não-Funcionais (Qualidade)**

1.  **Robustez:** O script deve tratar erros de forma graciosa (ex: falha na conexão com a API, dependências ausentes, arquivos não encontrados).
2.  **Experiência do Usuário (UX):** A interface deve ser limpa, com instruções claras e menus intuitivos. A tela deve ser limpa (`clear`) entre as transições de menu para evitar poluição visual.
3.  **Portabilidade:** O script deve funcionar em ambientes Linux (com `xdg-open`) e macOS (com `open`).
4.  **Manutenibilidade:** O código deve ser modularizado em funções e bem comentado.

#### **4. Dependências Obrigatórias**

O script deve verificar no início de sua execução se as seguintes ferramentas estão instaladas. Se alguma faltar, deve exibir uma mensagem de erro clara e encerrar.
*   `curl`
*   `jq`

#### **5. Estrutura do Projeto**

O projeto final deve conter dois arquivos:
1.  `pje_cli.sh` (com permissão de execução, `chmod +x pje_cli.sh`)
2.  `pje.conf` (arquivo de configuração)

#### **6. Especificação Detalhada dos Componentes**

##### **6.1. Arquivo de Configuração: `pje.conf`**
*   **Formato:** Arquivo de texto simples com variáveis de shell.
*   **Conteúdo Exemplo:**
    ```bash
    # Nome completo do advogado. O script deve cuidar da codificação para URL (%20).
    NOME_ADV="LUIZ PEIXOTO DE SIQUEIRA FILHO"
    # Número da OAB (apenas dígitos)
    NUMERO_OAB="94719"
    # Unidade Federativa da OAB
    UF_OAB="RJ"
    ```

##### **6.2. Script Principal: `pje_cli.sh`**

O script deve ser implementado usando funções para cada módulo lógico.

---
**Função: `main`**
*   **Lógica:**
    1.  Chama `verificar_dependencias()`.
    2.  Chama `carregar_configuracoes()`.
    3.  Entra no loop principal: chama `consultar_e_selecionar_processo()`.

---
**Função: `verificar_dependencias`**
*   **Lógica:**
    1.  Para cada comando em (`curl`, `jq`), use `command -v [comando]` para verificar se existe.
    2.  Se algum não existir, exiba `ERRO: A dependência '[comando]' não foi encontrada. Por favor, instale-a.` e saia com status `1`.

---
**Função: `carregar_configuracoes`**
*   **Lógica:**
    1.  Verifica se o arquivo `pje.conf` existe no mesmo diretório.
    2.  Se não existir, exiba `ERRO: Arquivo de configuração 'pje.conf' não encontrado.` e saia com status `1`.
    3.  Carregue as variáveis usando `source pje.conf`.
    4.  Verifique se as variáveis `NOME_ADV`, `NUMERO_OAB`, `UF_OAB` não estão vazias. Se estiverem, exiba um erro e saia.
    5.  Codifique a variável `NOME_ADV` para o formato de URL (substituindo espaços por `%20`).

---
**Função: `consultar_e_selecionar_processo`**
*   **Endpoint API:** `GET https://comunicaapi.pje.jus.br/api/v1/comunicacao`
*   **Parâmetros:** `numeroOab`, `ufOab`, `nomeAdvogado`
*   **Lógica:**
    1.  Limpe a tela (`clear`).
    2.  Exiba uma mensagem "Buscando processos...".
    3.  Execute a requisição `curl` para a API.
    4.  **Tratamento de Erro:** Verifique o status da resposta. Se a chamada `curl` falhar ou a resposta JSON não contiver o campo `"items"`, exiba "ERRO: Não foi possível obter a lista de processos da API." e retorne ao menu principal.
    5.  Use `jq` para extrair uma lista de números de processo **únicos**: `jq -r '.items[].numero_processo' | sort | uniq`. Armazene-os em um array Bash.
    6.  Se nenhum processo for encontrado, exiba "Nenhum processo encontrado para este advogado." e aguarde o usuário pressionar Enter para continuar.
    7.  Exiba a lista de processos numerada: `1) [processo_1]`, `2) [processo_2]`, etc., e uma opção `q) Sair`.
    8.  Peça ao usuário para escolher uma opção.
    9.  **Validação de Entrada:** Se a entrada não for um número válido dentro do intervalo da lista ou 'q', exiba "Opção inválida." e peça novamente.
    10. Se 'q', saia do script.
    11. Se for um número válido, chame `exibir_historico_e_acoes()` passando o número do processo selecionado como argumento.

---
**Função: `exibir_historico_e_acoes(numero_processo)`**
*   **Endpoint API:** `GET https://comunicaapi.pje.jus.br/api/v1/comunicacao`
*   **Parâmetros:** `numeroProcesso`
*   **Lógica:**
    1.  Limpe a tela (`clear`).
    2.  Exiba "Buscando histórico para o processo [numero_processo]...".
    3.  Execute a requisição `curl`.
    4.  Use `jq` para extrair e formatar uma lista de comunicações. Para cada item, armazene `data_disponibilizacao`, `tipoComunicacao` e `hash`. **É crucial armazenar o `hash` de cada comunicação em um array Bash para uso posterior.**
    5.  Exiba a lista numerada: `1) [data] - [tipo_comunicacao]`, etc., e uma opção `v) Voltar`.
    6.  Peça ao usuário para escolher uma opção.
    7.  **Validação de Entrada:** Se a entrada não for um número válido ou 'v', exiba "Opção inválida." e peça novamente.
    8.  Se 'v', retorne à função `consultar_e_selecionar_processo()`.
    9.  Se for um número válido, recupere o `hash` correspondente do array e chame a função `menu_acoes()` passando o `hash` e o `numero_processo` como argumentos.

---
**Função: `menu_acoes(hash, numero_processo)`**
*   **Lógica:**
    1.  Limpe a tela (`clear`).
    2.  Exiba um menu de ações:
        ```
        Processo: [numero_processo]
        Comunicação selecionada. Escolha uma ação:
        (a) Abrir no Navegador
        (b) Baixar PDF
        (v) Voltar para o histórico
        ```
    3.  Peça ao usuário para escolher uma opção.
    4.  **Validação de Entrada:** Use um loop `case` para tratar as opções `a`, `b`, `v`. Se for outra, exiba "Opção inválida.".
    5.  Se `a`:
        *   Construa a URL: `https://comunicaapi.pje.jus.br/api/v1/comunicacao/[hash]/certidao`
        *   Detecte o sistema operacional. Se for Linux, use `xdg-open "[URL]"`. Se for macOS, use `open "[URL]"`.
        *   Exiba "Abrindo no navegador...".
    6.  Se `b`:
        *   Construa a URL.
        *   Defina um nome de arquivo, por exemplo: `[numero_processo]_[hash].pdf`.
        *   Use `curl -L -o "[nome_arquivo]" "[URL]"` para baixar o arquivo. A flag `-L` é importante para seguir redirecionamentos.
        *   Exiba "PDF baixado como '[nome_arquivo]'.".
    7.  Se `v`, saia desta função e retorne para `exibir_historico_e_acoes()`.
    8.  Após uma ação (`a` ou `b`), aguarde o usuário pressionar Enter e reexiba o menu de ações.

#### **7. Resumo das Tarefas para o Agente de Código**

1.  Crie o arquivo `pje_cli.sh`.
2.  Implemente a função `verificar_dependencias()`.
3.  Implemente a função `carregar_configuracoes()` com tratamento de erros.
4.  Implemente a função `consultar_e_selecionar_processo()` usando `curl` e `jq` para obter uma lista única de processos e exibir um menu.
5.  Implemente a função `exibir_historico_e_acoes()` que, dado um número de processo, busca suas comunicações e as exibe em um menu.
6.  Implemente a função `menu_acoes()` com as opções de abrir no navegador e baixar o PDF.
7.  Crie a função `main` que orquestra a execução das outras funções em um fluxo lógico.
8.  Garanta que o código seja modular, comentado e que a experiência do usuário seja limpa (uso do comando `clear`).
9.  Crie um arquivo `pje.conf` de exemplo com a estrutura definida.