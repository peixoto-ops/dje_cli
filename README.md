# PJE CLI Assistant

[![Version](https://img.shields.io/github/v/release/peixoto-ops/dje_cli?include_prereleases&sort=semver&label=version)](https://github.com/peixoto-ops/dje_cli/releases)
[![License](https://img.shields.io/github/license/peixoto-ops/dje_cli)](LICENSE)
[![Build Status](https://github.com/peixoto-ops/dje_cli/actions/workflows/semantic-versioning.yml/badge.svg)](https://github.com/peixoto-ops/dje_cli/actions/workflows/semantic-versioning.yml)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-blue)](#)
[![Conventional Commits](https://img.shields.io/badge/Commits-Conventional-e10079?logo=git)](https://conventionalcommits.org)
[![Semantic Versioning](https://img.shields.io/badge/SemVer-2.0.0-green)](https://semver.org/)
[![GitHub Pages](https://img.shields.io/badge/GitHub%20Pages-Docs-blue)](https://peixoto-ops.github.io/dje_cli/)

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
- **Gerenciamento de projeto**: Quadro Kanban integrado para rastreamento de tarefas
- **Métricas e insights**: Monitoramento contínuo de crescimento e saúde do projeto

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
- [Gerenciamento de Projeto](#-gerenciamento-de-projeto)
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

### Scripts de Automação

O projeto inclui vários scripts de automação:

```bash
# Gerenciamento de branches
./scripts/branch_manager.sh feature nome-da-funcionalidade

# Build e distribuição
./scripts/build.sh build

# Criação de releases
./scripts/release.sh patch

# Coleta de métricas
./scripts/metrics.sh report

# Tarefas automatizadas
./scripts/automation.sh validate

# Verificação de qualidade de código
./scripts/automation.sh check-quality
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
├── docs/                  # Documentação
│   ├── api/               # Documentação da API
│   ├── guia/              # Guias de usuário e desenvolvimento
│   ├── specs/             # Especificações técnicas
│   └── protocolos/        # Protocolos de documentação
├── src/                   # Código-fonte
│   ├── pje_cli.sh         # Script principal
│   └── config/            # Arquivos de configuração
├── conversas/             # Conversas com assistentes de IA
├── scripts/               # Scripts auxiliares
│   ├── branch_manager.sh  # Gerenciamento de branches
│   ├── build.sh          # Script de build
│   ├── release.sh        # Script de releases
│   ├── metrics.sh        # Coleta de métricas
│   └── automation.sh     # Tarefas automatizadas
├── tests/                 # Casos de teste
├── _docs/                 # Documentação para GitHub Pages
├── .github/workflows/     # Workflows de CI/CD
├── releases/              # Releases automatizados
├── metrics/               # Métricas coletadas
├── reports/               # Relatórios gerados
├── CHANGELOG.md           # Histórico de mudanças
├── LICENSE                # Licença do projeto
├── _config.yml            # Configuração do GitHub Pages
├── package.json           # Configuração para ferramentas
├── QWEN.md                # Documentação do Qwen
├── README.md              # Este arquivo
└── VERSION                # Controle de versão
```

## 🔁 Workflows

O projeto inclui workflows automatizados do GitHub Actions:

- **Semantic Versioning**: Analisa commits convencionais para determinar a próxima versão
- **Release**: Cria automaticamente tags e releases com changelog
- **Package**: Gera pacotes de instalação para diferentes plataformas (tar.gz, zip)
- **Documentation**: Build e deploy automático da documentação
- **Metrics**: Coleta e análise de métricas do repositório
- **Validation**: Verificação de qualidade e segurança do código

## 📝 Convenções

Este projeto segue:

- **Conventional Commits**: Padrão para mensagens de commit
- **Semantic Versioning**: Versionamento baseado em tipos de mudanças
- **Frontmatter YAML**: Metadados estruturados em arquivos de documentação

## 🗂️ Gerenciamento de Projeto

O projeto utiliza:

- **GitHub Issues**: Rastreamento de bugs e solicitações de funcionalidades
- **Kanban Board**: Organização visual do processo de desenvolvimento
- **Tags e Releases**: Versionamento semântico para releases estáveis
- **Wiki**: Documentação complementar e discussões técnicas detalhadas
- **Métricas**: Monitoramento de crescimento e saúde do projeto

### Política de Commits

- Commits frequentes para evitar perda de trabalho
- Mensagens seguindo o padrão Conventional Commits
- Referências a issues e PRs quando apropriado
- Commits atômicos e com mudanças lógicas coesas

## 🤝 Contribuindo

Contribuições são bem-vindas! Por favor, leia nosso [Guia de Contribuição](docs/guia/contribuicao.md) e os documentos complementares:

- [Política de Commits](docs/guia/politica_commits.md)
- [Política de Branches](docs/guia/politica_branches.md)
- [Integração Kanban](docs/guia/integracao_kanban.md)
- [Convenção de Tags](docs/guia/convencao_tags.md)
- [Uso da Wiki](docs/guia/wiki_projeto.md)

Para começar:

1. Faça fork do projeto
2. Crie sua branch de funcionalidade: `git checkout -b feature/NomeDaFuncionalidade`
3. Use o script de gerenciamento de branches: `./scripts/branch_manager.sh feature NomeDaFuncionalidade`
4. Faça commit das suas alterações: `git commit -m 'feat: mensagem descritiva'`
5. Faça push para a branch: `git push origin feature/NomeDaFuncionalidade`
6. Abra um Pull Request

## 📊 Métricas do Projeto

Monitoramos continuamente:

- Crescimento de estrelas e forks
- Frequência de commits e contribuições
- Tempo médio de resposta a issues
- Qualidade e cobertura de testes
- Uso e feedback da comunidade

## 📄 Licença

Este projeto está licenciado sob a MIT License - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 📞 Contato

Luiz Peixoto - luizpeixoto@duckgo.com

Esse é um email de redirecionamento do DuckGo para luizpeixoto.adv@gmail.com, garantindo maior privacidade e segurança.

## 📚 Documentação Adicional

- [Documentação do Projeto](https://peixoto-ops.github.io/dje_cli/) - Documentação completa hospedada no GitHub Pages
- [Quadro Kanban](https://github.com/orgs/peixoto-ops/projects/8) - Gerenciamento de tarefas e desenvolvimento
- [Wiki](https://github.com/peixoto-ops/dje_cli/wiki) - Documentação complementar e discussões técnicas

## ⭐ Apreciação

Se este projeto foi útil para você, considere deixar uma estrela! É uma forma simples de mostrar apreço pelo trabalho e ajudar outros a encontrarem o projeto.

---

Made with ❤️ for the legal community