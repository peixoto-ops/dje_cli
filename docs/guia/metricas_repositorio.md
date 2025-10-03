# Métricas e Gráficos de Crescimento do Repositório

## Visão Geral

Este documento descreve como coletar, monitorar e visualizar métricas para acompanhar o crescimento e a saúde do projeto PJE CLI Assistant.

## Métricas de Repositório

### Métricas Básicas
- **Stars**: Indicador de interesse e popularidade
- **Forks**: Indicador de engajamento e reutilização
- **Watchers**: Indicador de seguidores ativos
- **Issues**: Indicador de atividade e feedback da comunidade
- **Pull Requests**: Indicador de contribuições da comunidade

### Métricas de Atividade
- **Commits por período**: Frequência de desenvolvimento
- **Contribuidores**: Número de pessoas contribuindo
- **Issues abertas/fechadas**: Saúde do backlog
- **Pull Requests merged**: Taxa de aceitação de contribuições
- **Tempo médio de resposta**: Tempo para responder a issues/PRs

### Métricas de Código
- **Linhas de código**: Tamanho do projeto
- **Cobertura de testes**: Qualidade do código
- **Pull Requests por commit**: Frequência de revisão
- **Issues resolvidas por PR**: Eficiência do desenvolvimento

## Fontes de Dados

### GitHub Insights
- Gráficos de contribuições
- Gráficos de frequência de commits
- Gráficos de abertura e fechamento de issues
- Gráficos de pull requests

### GitHub API
- Dados detalhados sobre repositório
- Estatísticas de contribuidores
- Histórico de releases
- Métricas de engajamento

### GitHub Pages
- Estatísticas de visualizações da documentação
- Páginas mais acessadas
- Tráfego ao longo do tempo

## Implementação de Scripts de Coleta

### Script de Métricas Básicas

O script `scripts/metrics.sh` coleta métricas básicas do repositório:

```bash
#!/usr/bin/env bash

# Coleta métricas básicas do repositório
# Uso: ./scripts/metrics.sh

REPO="peixoto-ops/dje_cli"
OUTPUT_DIR="metrics"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$OUTPUT_DIR"

# Obter dados usando GitHub API
echo "Coletando métricas para $REPO..."

# Coletar métricas do repositório
curl -s "https://api.github.com/repos/$REPO" > "$OUTPUT_DIR/repo_$TIMESTAMP.json"

# Coletar estatísticas de contribuidores
curl -s "https://api.github.com/repos/$REPO/contributors" > "$OUTPUT_DIR/contributors_$TIMESTAMP.json"

# Coletar últimas issues
curl -s "https://api.github.com/repos/$REPO/issues?state=all&per_page=100" > "$OUTPUT_DIR/issues_$TIMESTAMP.json"

# Coletar últimos PRs
curl -s "https://api.github.com/repos/$REPO/pulls?state=all&per_page=100" > "$OUTPUT_DIR/pulls_$TIMESTAMP.json"

echo "Métricas coletadas em: $OUTPUT_DIR"
```

### Script de Relatório Automático

O script `scripts/report.sh` gera relatórios periódicos:

```bash
#!/usr/bin/env bash

# Gera relatório periódico de métricas
# Uso: ./scripts/report.sh [daily|weekly|monthly]

PERIOD="${1:-weekly}"
REPO="peixoto-ops/dje_cli"
REPORT_DIR="reports"
DATE_STAMP=$(date +%Y%m%d)

mkdir -p "$REPORT_DIR"

# Coletar dados e gerar relatório
echo "# Relatório de Métricas - $PERIOD" > "$REPORT_DIR/metrics_$DATE_STAMP.md"
echo "Data: $(date)" >> "$REPORT_DIR/metrics_$DATE_STAMP.md"
echo "" >> "$REPORT_DIR/metrics_$DATE_STAMP.md"

# Simulação de obtenção de métricas
echo "## Métricas Atuais" >> "$REPORT_DIR/metrics_$DATE_STAMP.md"
echo "" >> "$REPORT_DIR/metrics_$DATE_STAMP.md"

# Usar GitHub API para obter métricas
# Isso seria implementado com comandos curl e jq para processar os dados

echo "Relatório gerado em: $REPORT_DIR/metrics_$DATE_STAMP.md"
```

## Integração com GitHub Actions

### Workflow de Coleta de Métricas

O workflow `.github/workflows/metrics.yml` coleta métricas automaticamente:

```yaml
name: Coleta de Métricas

on:
  schedule:
    - cron: '0 0 * * 0'  # Semanalmente
  workflow_dispatch:

jobs:
  collect-metrics:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Coletar métricas
        run: |
          ./scripts/metrics.sh

      - name: Armazenar métricas
        uses: actions/upload-artifact@v3
        with:
          name: metrics-${{ github.run_number }}
          path: metrics/
```

## Visualização de Métricas

### GitHub Insights
- Acessar via `https://github.com/peixoto-ops/dje_cli/pulse`
- Gráficos de atividade e contribuições
- Métricas de issues e pull requests

### GitHub Community Profile
- Dashboard de saúde do projeto
- Verificação de padrões de comunidade
- Métricas de documentação

## Relatórios Periódicos

### Relatório Semanal
- Estatísticas de commits da semana
- Issues abertas e fechadas
- Pull requests merged
- Novas contribuições

### Relatório Mensal
- Tendências de crescimento
- Análise de engajamento
- Atividade de contribuidores
- Avaliação de objetivos mensais

### Relatório Anual
- Crescimento do projeto
- Evolução da comunidade
- Análise de impacto
- Planejamento estratégico

## Métricas de Engajamento da Comunidade

### Participação
- Número de contribuidores únicos
- Frequência de contribuições
- Tempo médio de resposta a issues
- Taxa de aceitação de PRs

### Satisfação
- Tempo médio para fechamento de issues
- Feedback em releases
- Atividade na wiki e discussões
- Reutilização do projeto (forks, dependências)

## Monitoramento de Saúde do Projeto

### Atividade de Desenvolvimento
- Frequência de commits
- Tempo entre releases
- Estabilidade do código
- Atividade de manutenção

### Qualidade de Código
- Cobertura de testes
- Qualidade do código (análise estática)
- Tempo médio de correção de bugs
- Proporção de código técnico (refatoração)

## Dashboard de Métricas

### Componentes do Dashboard
- Estatísticas básicas em destaque
- Gráficos de tendência
- Alertas para anomalias
- Resumo de atividades recentes

### Implementação
- Pode ser feito com GitHub Pages e JavaScript
- Integração com GitHub API
- Atualização automática via GitHub Actions
- Visualização interativa

## Métricas de Sucesso do Projeto

### Indicadores de Adoção
- Frequência de downloads (quando aplicável)
- Integração com outros projetos
- Menções em artigos ou tutoriais
- Utilização em produções

### Indicadores de Qualidade
- Baixa taxa de bugs reportados
- Alta qualidade de contribuições
- Documentação completa e atualizada
- Processo de desenvolvimento maduro

## Boas Práticas

### Coleta de Métricas
- Coletar dados periodicamente
- Armazenar históricos para comparação
- Garantir privacidade dos dados
- Documentar metodologia

### Análise de Métricas
- Interpretar dados no contexto
- Identificar tendências e padrões
- Comparar com benchmarks
- Comunicar insights relevantes

### Comunicação de Métricas
- Compartilhar métricas com a comunidade
- Explicar decisões baseadas em dados
- Manter transparência no processo
- Incentivar contribuições baseadas em métricas