# PJE CLI Assistant

[![Version](https://img.shields.io/github/v/release/seu-usuario/dje_cli?include_prereleases&sort=semver&label=version)](https://github.com/seu-usuario/dje_cli/releases)
[![License](https://img.shields.io/github/license/seu-usuario/dje_cli)](LICENSE)
[![Build Status](https://github.com/seu-usuario/dje_cli/actions/workflows/semantic-versioning.yml/badge.svg)](https://github.com/seu-usuario/dje_cli/actions/workflows/semantic-versioning.yml)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-blue)](#)
[![Conventional Commits](https://img.shields.io/badge/Commits-Conventional-e10079?logo=git)](https://conventionalcommits.org)
[![Semantic Versioning](https://img.shields.io/badge/SemVer-2.0.0-green)](https://semver.org/)

> Um assistente de linha de comando em Bash para interagir com a API de Comunicação do Processo Judicial Eletrônico (PJE) do Brasil. Esta ferramenta permite que advogados consultem e gerenciem seus processos judiciais diretamente do terminal, oferecendo uma alternativa eficiente à interface web.

## 🚀 Características

- **Consulta de processos**: Busque todos os processos associados ao seu OAB
- **Histórico de andamentos**: Visualize a linha do tempo de cada processo
- **Ações rápidas**: Abra documentos no navegador ou faça download em PDF
- **Multiplataforma**: Compatível com Linux, macOS e Windows (via Git Bash ou WSL)
- **Configuração flexível**: Arquivo de configuração externo para seus dados
- **Versionamento semântico**: Releases automatizados com CI/CD
- **Automatização completa**: Workflows para versionamento, releases e pacotes
- **Documentação estruturada**: Frontmatter YAML para metadados de documentos

## 📋 Índice

- [Características](#-características)
- [Requisitos](#-requisitos)
- [Instalação](#-instalação)
- [Uso](#-uso)
- [Configuração](#-configuração)
- [Compatibilidade](#-compatibilidade)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Workflows](#-workflows)
- [Convenções](#-convenções)
- [Contribuindo](#-contribuindo)
- [Licença](#-licença)
- [Contato](#-contato)

## 🛠️ Requisitos

- Bash (4.0+)
- curl
- jq
- Git (para clonar o repositório)

## 📦 Instalação

### Via Git

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/dje_cli.git
   cd dje_cli
   ```

2. Instale as dependências:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install curl jq
   
   # CentOS/RHEL
   sudo dnf install curl jq
   
   # macOS
   brew install curl jq
   ```

3. Configure suas credenciais:
   ```bash
   cp src/config/pje.conf.example src/config/pje.conf
   # Edite src/config/pje.conf com seus dados
   ```

4. Torne o script executável:
   ```bash
   chmod +x src/pje_cli.sh
   ```

## ▶️ Uso

### Execução direta

Execute o script:
```bash
./src/pje_cli.sh
```

O script apresentará um menu interativo para navegar por seus processos e realizar ações nos documentos.

### Usando o script de build

O projeto inclui um script de build para facilitar diferentes tarefas:

```bash
# Preparar diretório de build
./scripts/build.sh build

# Criar arquivo de distribuição (tar.gz ou zip)
./scripts/build.sh archive

# Instalar localmente
./scripts/build.sh install

# Exibir ajuda
./scripts/build.sh help
```

## ⚙️ Configuração

Antes de executar, certifique-se de configurar suas credenciais:

1. Copie o arquivo de exemplo:
   ```bash
   cp src/config/pje.conf.example src/config/pje.conf
   ```

2. Edite `src/config/pje.conf` com seus dados:
   - `NOME_ADV`: Seu nome completo
   - `NUMERO_OAB`: Número da sua OAB (apenas dígitos)
   - `UF_OAB`: Unidade Federativa da sua OAB

## 🌐 Compatibilidade

O script é compatível com:

- **Linux**: Todos os principais sistemas baseados em Debian, Red Hat, Arch, etc.
- **macOS**: Versões 10.14 (Mojave) ou superior
- **Windows**: 10 ou 11 com Git Bash, WSL (Windows Subsystem for Linux)

A detecção automática de sistema permite que os comandos corretos sejam usados em cada plataforma.

## 📁 Estrutura do Projeto

```
dje_cli/
├── docs/              # Documentação
│   ├── api/           # Documentação da API
│   ├── guia/          # Guias de usuário
│   ├── specs/         # Especificações técnicas
│   └── protocolos/    # Protocolos de documentação
├── src/               # Código-fonte
│   └── config/        # Arquivos de configuração
├── conversas/         # Conversas com assistentes de IA
├── scripts/           # Scripts auxiliares
├── tests/             # Casos de teste
├── .github/workflows/ # Workflows de CI/CD
├── releases/          # Releases automatizados
├── CHANGELOG.md       # Histórico de mudanças
├── LICENSE            # Licença do projeto
├── package.json       # Configuração para ferramentas
├── QWEN.md            # Documentação do Qwen
├── README.md          # Este arquivo
└── VERSION            # Controle de versão
```

## 🔁 Workflows

O projeto inclui workflows automatizados do GitHub Actions:

- **Semantic Versioning**: Analisa commits convencionais para determinar a próxima versão
- **Release**: Cria automaticamente tags e releases com changelog
- **Package**: Gera pacotes de instalação para diferentes plataformas (tar.gz, zip)

## 📝 Convenções

Este projeto segue:

- **Conventional Commits**: Padrão para mensagens de commit
- **Semantic Versioning**: Versionamento baseado em tipos de mudanças
- **Frontmatter YAML**: Metadados estruturados em arquivos de documentação

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor, leia nosso [Guia de Contribuição](docs/guia/contribuicao.md) para detalhes sobre como:

- Configurar seu ambiente de desenvolvimento
- Seguir nossas convenções de código e commit
- Submeter Pull Requests
- Reportar problemas
- Solicitar novas funcionalidades

Para commits, siga o padrão Conventional Commits:
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Mudanças na documentação
- `test`: Adição ou modificação de testes
- `chore`: Tarefas de manutenção

## 📄 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Contato

Luiz Peixoto - luizpeixoto@duckgo.com

Esse é um email de redirecionamento do DuckGo para luizpeixoto.adv@gmail.com, garantindo maior privacidade e segurança.

## ⭐ Apreciação

Se este projeto foi útil para você, considere deixar uma estrela! É uma forma simples de mostrar apreço pelo trabalho e ajudar outros a encontrarem o projeto.

---

Made with ❤️ for the legal community