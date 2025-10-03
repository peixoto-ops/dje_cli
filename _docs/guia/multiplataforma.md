---
layout: default
title: "Guia de Uso Multiplataforma"
nav_order: 5
description: "Como usar o PJE CLI Assistant em diferentes sistemas operacionais"
permalink: /guia/multiplataforma
parent: "Guias"
tags:
  - guia
  - uso
  - multiplataforma
  - instalação
project: "PJE CLI Assistant"
related:
  - "README.md"
  - "docs/specs/spec_kit.md"
---

# Guia de Uso Multiplataforma

Este guia explica como usar o PJE CLI Assistant em diferentes sistemas operacionais (Linux, macOS e Windows).

## Compatibilidade

O script foi projetado para ser compatível com:
- **Linux**: Todos os principais sistemas baseados em Debian, Red Hat, Arch, etc.
- **macOS**: Versões 10.14 (Mojave) ou superior
- **Windows**: 10 ou 11 com Git Bash, WSL (Windows Subsystem for Linux) ou PowerShell com suporte a comandos Unix

## Instalação por Sistema

### Linux e macOS

1. **Instale as dependências:**
   ```bash
   # Ubuntu/Debian
   sudo apt-get install curl jq
   
   # CentOS/RHEL/Fedora
   sudo dnf install curl jq
   
   # macOS
   brew install curl jq
   ```

2. **Baixe o script:**
   ```bash
   # Clone o repositório ou baixe os arquivos
   git clone https://github.com/seu-usuario/dje_cli.git
   cd dje_cli
   ```

3. **Configure:**
   ```bash
   cp src/config/pje.conf.example src/config/pje.conf
   # Edite src/config/pje.conf com seus dados
   ```

4. **Torne executável:**
   ```bash
   chmod +x src/pje_cli.sh
   ```

### Windows

#### Opção 1: Git Bash

1. **Instale o Git para Windows** (que inclui Git Bash)
2. **Instale jq para Windows**:
   - Baixe o binário de https://jqlang.github.io/jq/download/
   - Adicione ao PATH do sistema
3. **Siga as instruções de Linux/macOS acima**

#### Opção 2: WSL (Windows Subsystem for Linux)

1. **Instale o WSL**:
   ```powershell
   wsl --install
   ```

2. **Abra o WSL** e siga as instruções de Linux acima

#### Opção 3: PowerShell com WSL

Você pode chamar o script do WSL diretamente do PowerShell:
```powershell
wsl -e bash -c "cd /mnt/c/path/to/dje_cli && ./src/pje_cli.sh"
```

## Detecção de Sistema no Script

O script inclui funções para detectar automaticamente o sistema operacional e ajustar o comportamento conforme necessário:

```bash
detectar_sistema() {
    case "$(uname -s)" in
        Linux*)     sys=Linux;;
        Darwin*)    sys=Mac;;
        CYGWIN*|MINGW*|MSYS*) sys=Windows;;
        *)          sys="Desconhecido";;
    esac
    echo "$sys"
}

abrir_navegador() {
    local url="$1"
    case "$(detectar_sistema)" in
        Linux*)     xdg-open "$url" ;;
        Mac*)       open "$url" ;;
        Windows*)   start "$url" ;;
        *)          echo "Sistema não suportado para abrir navegador" ;;
    esac
}
```

## Configurações Específicas

### Linux

- O comando padrão para abrir URLs é `xdg-open`
- As dependências podem ser instaladas via gerenciador de pacotes do sistema

### macOS

- O comando padrão para abrir URLs é `open`
- O gerenciador de pacotes Homebrew é recomendado para dependências

### Windows

- O comando padrão para abrir URLs é `start` (no Git Bash ou PowerShell)
- Pode ser necessário instalar jq manualmente como binário

## Problemas Comuns e Soluções

### Erro: "command not found" para jq ou curl

- Verifique se as dependências estão instaladas
- Verifique se estão no PATH

### Problemas com permissão de execução

- No Linux/macOS, rode: `chmod +x src/pje_cli.sh`
- No Windows com Git Bash, verifique as permissões do arquivo

### Problemas com codificação de caracteres

- Verifique se o terminal está configurado para UTF-8
- Verifique se o nome no pje.conf está codificado corretamente

## Testando a Compatibilidade

Execute o script e selecione as diferentes opções para testar:
- Consulta de processos
- Visualização de histórico
- Abertura de documentos no navegador
- Download de PDFs

A detecção de sistema garantirá que os comandos corretos sejam usados em cada plataforma.