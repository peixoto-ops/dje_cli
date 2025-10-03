# Sumário de Documentação - PJE CLI Assistant

## Visão Geral do Projeto
- [README.md](README.md) - Documentação principal do projeto
- [QWEN.md](QWEN.md) - Documentação técnica para assistentes de IA

## Documentação Técnica
- [Especificação Técnica](docs/specs/spec_kit.md) - Detalhes técnicos do projeto
- [Documentação da API](docs/api/orienta_documenta_api.md) - Especificações da API do PJE
- [Protocolo de Documentação](docs/protocolos/documentacao_frontmatter.md) - Uso de frontmatter YAML

## Guias de Desenvolvimento
- [Guia de Contribuição](docs/guia/contribuicao.md) - Como contribuir para o projeto
- [Convenções de Commit](docs/guia/convencao_commit.md) - Padrões para mensagens de commit
- [Guia Multiplataforma](docs/guia/multiplataforma.md) - Compatibilidade entre sistemas
- [Política de Branches](docs/guia/politica_branches.md) - Gestão de branches do projeto
- [Integração Kanban](docs/guia/integracao_kanban.md) - Uso do quadro Kanban
- [Política de Commits](docs/guia/politica_commits.md) - Práticas de commits periódicos
- [Convenção de Tags](docs/guia/convencao_tags.md) - Sistema de versionamento
- [Uso da Wiki](docs/guia/wiki_projeto.md) - Diretrizes para a wiki
- [Métricas do Repositório](docs/guia/metricas_repositorio.md) - Monitoramento e métricas

## Scripts de Automação
- [branch_manager.sh](scripts/branch_manager.sh) - Gerenciamento de branches
- [build.sh](scripts/build.sh) - Script de build e empacotamento
- [release.sh](scripts/release.sh) - Automação de releases e tags
- [metrics.sh](scripts/metrics.sh) - Coleta de métricas do repositório
- [automation.sh](scripts/automation.sh) - Tarefas automatizadas
- [test_pje_cli.sh](tests/test_pje_cli.sh) - Testes para o script principal

## Configuração
- [pje.conf.example](src/config/pje.conf.example) - Exemplo de arquivo de configuração

## Histórico
- [CHANGELOG.md](CHANGELOG.md) - Histórico de mudanças
- [VERSION](VERSION) - Controle de versão atual
- [package.json](package.json) - Configuração para ferramentas
- [LICENSE](LICENSE) - Termos de licença
- [conversas/chat-Zai.md](conversas/chat-Zai.md) - Conversas iniciais com assistente de IA

## Documentação para GitHub Pages
- [_config.yml](.config.yml) - Configuração do Jekyll
- [index.md](index.md) - Página inicial do site
- [_docs/api/](_docs/api/) - Documentação da API para GitHub Pages
- [_docs/guia/](_docs/guia/) - Guias para GitHub Pages
- [_docs/specs/](_docs/specs/) - Especificações para GitHub Pages
- [_docs/protocolos/](_docs/protocolos/) - Protocolos para GitHub Pages

## Workflows do GitHub Actions
- [semantic-versioning.yml](.github/workflows/semantic-versioning.yml) - Versionamento semântico
- [release.yml](.github/workflows/release.yml) - Criação de releases
- [package.yml](.github/workflows/package.yml) - Empacotamento
- [jekyll.yml](.github/workflows/jekyll.yml) - Build do GitHub Pages
- [validate-docs.yml](.github/workflows/validate-docs.yml) - Validação de documentação
- [metrics.yml](.github/workflows/metrics.yml) - Coleta de métricas (exemplo)

## Templates
- [pull_request_template.md](.github/pull_request_template.md) - Modelo para Pull Requests
- [bug_report.md](.github/ISSUE_TEMPLATE/bug_report.md) - Modelo para relatórios de bug
- [feature_request.md](.github/ISSUE_TEMPLATE/feature_request.md) - Modelo para solicitações de funcionalidades