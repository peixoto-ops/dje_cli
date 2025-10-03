#!/usr/bin/env bash

# Script de coleta de métricas para PJE CLI Assistant
# Este script coleta métricas básicas do repositório

set -e  # Sai se algum comando falhar

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$PROJECT_ROOT/metrics"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

show_help() {
    echo "Script de coleta de métricas para PJE CLI Assistant"
    echo ""
    echo "Uso: $0 [opção]"
    echo ""
    echo "Opções:"
    echo "  collect      - Coleta métricas básicas (padrão)"
    echo "  report       - Gera relatório de métricas"
    echo "  show         - Mostra métricas atuais"
    echo "  help         - Mostra esta mensagem"
    echo ""
    echo "Exemplos:"
    echo "  $0 collect   - Coleta métricas do repositório"
    echo "  $0 report    - Gera relatório resumido"
    echo "  $0 show      - Mostra métricas resumidas"
}

collect_metrics() {
    echo "Coletando métricas para o repositório PJE CLI Assistant..."

    mkdir -p "$OUTPUT_DIR"

    local repo="peixoto-ops/dje_cli"
    
    # Obter dados do repositório
    echo "Coletando dados do repositório..."
    curl -s "https://api.github.com/repos/$repo" > "$OUTPUT_DIR/repo_$TIMESTAMP.json"

    # Obter contribuidores
    echo "Coletando dados de contribuidores..."
    curl -s "https://api.github.com/repos/$repo/contributors" > "$OUTPUT_DIR/contributors_$TIMESTAMP.json"

    # Obter últimas issues (ativas e fechadas)
    echo "Coletando dados de issues..."
    curl -s "https://api.github.com/repos/$repo/issues?state=all&per_page=100" > "$OUTPUT_DIR/issues_$TIMESTAMP.json"

    # Obter últimos PRs (abertos e fechados)
    echo "Coletando dados de pull requests..."
    curl -s "https://api.github.com/repos/$repo/pulls?state=all&per_page=100" > "$OUTPUT_DIR/pulls_$TIMESTAMP.json"

    # Obter releases
    echo "Coletando dados de releases..."
    curl -s "https://api.github.com/repos/$repo/releases" > "$OUTPUT_DIR/releases_$TIMESTAMP.json"

    echo "Métricas coletadas em: $OUTPUT_DIR"
    echo "Arquivos gerados:"
    ls -la "$OUTPUT_DIR" | grep "$TIMESTAMP"
}

show_metrics() {
    local repo="peixoto-ops/dje_cli"
    
    # Obter dados básicos do repositório
    local repo_data=$(curl -s "https://api.github.com/repos/$repo")
    
    local stars=$(echo "$repo_data" | grep -o '"stargazers_count":[0-9]*' | cut -d':' -f2)
    local forks=$(echo "$repo_data" | grep -o '"forks_count":[0-9]*' | cut -d':' -f2)
    local issues=$(curl -s "https://api.github.com/repos/$repo/issues?state=open&per_page=1" | jq 'length' 2>/dev/null || echo "N/A")
    local contributors=$(curl -s "https://api.github.com/repos/$repo/contributors?per_page=1" | jq 'length' 2>/dev/null || echo "N/A")
    
    echo "=== Métricas Atuais do Repositório ==="
    echo "Repositório: $repo"
    echo "Stars: $stars"
    echo "Forks: $forks"
    echo "Issues abertas: $issues"
    echo "Contribuidores: $contributors"
    echo "====================================="
}

generate_report() {
    echo "Gerando relatório de métricas..."

    local report_dir="$PROJECT_ROOT/reports"
    mkdir -p "$report_dir"
    
    local date_stamp=$(date)
    local report_file="$report_dir/metrics_report_$TIMESTAMP.md"
    
    {
        echo "# Relatório de Métricas - PJE CLI Assistant"
        echo ""
        echo "Data de geração: $date_stamp"
        echo ""
        echo "## Métricas Básicas"
        
        local repo="peixoto-ops/dje_cli"
        local repo_data=$(curl -s "https://api.github.com/repos/$repo" 2>/dev/null)
        
        if [ $? -eq 0 ]; then
            local stars=$(echo "$repo_data" | jq -r '.stargazers_count' 2>/dev/null || echo "N/A")
            local forks=$(echo "$repo_data" | jq -r '.forks_count' 2>/dev/null || echo "N/A")
            local language=$(echo "$repo_data" | jq -r '.language' 2>/dev/null || echo "N/A")
            
            echo "- Stars: $stars"
            echo "- Forks: $forks"
            echo "- Linguagem principal: $language"
        else
            echo "- Erro ao obter dados do repositório"
        fi
        
        echo ""
        echo "## Atividade Recente"
        local commits=$(curl -s "https://api.github.com/repos/$repo/commits?per_page=5" 2>/dev/null | jq 'length' 2>/dev/null || echo "N/A")
        echo "- Commits recentes (últimos 5): $commits"
        
        local open_issues=$(curl -s "https://api.github.com/repos/$repo/issues?state=open&per_page=1" 2>/dev/null | jq 'length' 2>/dev/null || echo "N/A")
        echo "- Issues abertas: $open_issues"
        
        local open_prs=$(curl -s "https://api.github.com/repos/$repo/pulls?state=open&per_page=1" 2>/dev/null | jq 'length' 2>/dev/null || echo "N/A")
        echo "- Pull Requests abertos: $open_prs"
        
        echo ""
        echo "## Detalhes"
        echo "Os dados completos estão disponíveis no diretório: $OUTPUT_DIR"
        echo ""
        echo "Gerado por: scripts/metrics.sh"
    } > "$report_file"
    
    echo "Relatório gerado em: $report_file"
}

case "${1:-collect}" in
    collect)
        collect_metrics
        ;;
    show)
        show_metrics
        ;;
    report)
        generate_report
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Opção desconhecida: $1"
        echo ""
        show_help
        exit 1
        ;;
esac