#!/usr/bin/env bash

# Script de automação para tarefas repetitivas do PJE CLI Assistant
# Este script reúne várias funções úteis para o desenvolvimento

set -e  # Sai se algum comando falhar

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

show_help() {
    echo "Script de automação para tarefas repetitivas do PJE CLI Assistant"
    echo ""
    echo "Uso: $0 [comando] [argumentos]"
    echo ""
    echo "Comandos:"
    echo "  backup            - Faz backup do estado atual do trabalho"
    echo "  setup             - Configura o ambiente de desenvolvimento"
    echo "  validate          - Valida o ambiente e dependências"
    echo "  test              - Executa todos os testes do projeto"
    echo "  clean             - Limpa arquivos temporários e cache"
    echo "  update-deps       - Atualiza dependências do projeto"
    echo "  check-quality     - Verifica qualidade do código"
    echo "  help              - Mostra esta mensagem"
    echo ""
    echo "Exemplos:"
    echo "  $0 backup"
    echo "  $0 setup"
    echo "  $0 validate"
    echo "  $0 test"
}

backup_work() {
    echo "Fazendo backup do estado atual do trabalho..."
    
    local current_branch=$(git branch --show-current)
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_branch="backup/$timestamp"
    
    # Verificar se há alterações não commitadas
    if git diff-index --quiet HEAD --; then
        echo "Nenhuma alteração não commitada para fazer backup"
        return 0
    fi
    
    # Salvar alterações no stash
    local stash_msg="backup-$timestamp-$(git branch --show-current)"
    git stash push -m "$stash_msg"
    
    echo "Backup realizado no stash com mensagem: $stash_msg"
    echo "Para restaurar: git stash pop"
}

setup_environment() {
    echo "Configurando ambiente de desenvolvimento..."
    
    # Verificar dependências
    local deps=("bash" "curl" "jq" "git")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo "ERRO: As seguintes dependências estão ausentes: ${missing[*]}"
        echo "Por favor, instale-as antes de continuar."
        return 1
    fi
    
    # Verificar se os scripts principais existem
    if [ ! -f "$PROJECT_ROOT/src/pje_cli.sh" ]; then
        echo "ERRO: Script principal não encontrado em $PROJECT_ROOT/src/pje_cli.sh"
        return 1
    fi
    
    # Copiar configuração de exemplo se não existir
    if [ ! -f "$PROJECT_ROOT/src/config/pje.conf" ]; then
        echo "Criando arquivo de configuração a partir do exemplo..."
        cp "$PROJECT_ROOT/src/config/pje.conf.example" "$PROJECT_ROOT/src/config/pje.conf"
        echo "Por favor, edite $PROJECT_ROOT/src/config/pje.conf com seus dados"
    fi
    
    echo "Ambiente configurado com sucesso!"
}

validate_environment() {
    echo "Validando ambiente de desenvolvimento..."
    
    local errors=0
    
    # Verificar dependências
    echo "Verificando dependências..."
    local deps=("bash" "curl" "jq" "git")
    
    for dep in "${deps[@]}"; do
        if command -v "$dep" &> /dev/null; then
            echo "✓ $dep está instalado"
        else
            echo "✗ $dep NÃO está instalado"
            ((errors++))
        fi
    done
    
    # Verificar sintaxe do script principal
    echo "Verificando sintaxe do script principal..."
    if bash -n "$PROJECT_ROOT/src/pje_cli.sh"; then
        echo "✓ Sintaxe do script principal está correta"
    else
        echo "✗ Erro de sintaxe no script principal"
        ((errors++))
    fi
    
    # Verificar arquivos de configuração
    echo "Verificando arquivos de configuração..."
    if [ -f "$PROJECT_ROOT/src/config/pje.conf" ]; then
        echo "✓ Arquivo de configuração encontrado"
    else
        echo "⚠ Arquivo de configuração não encontrado (pode ser criado com 'setup')"
    fi
    
    if [ $errors -eq 0 ]; then
        echo "✓ Validação concluída com sucesso"
        return 0
    else
        echo "✗ Validação encontrou $errors erro(s)"
        return 1
    fi
}

run_tests() {
    echo "Executando testes do projeto..."
    
    if [ -f "$PROJECT_ROOT/tests/test_pje_cli.sh" ]; then
        echo "Executando testes do script principal..."
        bash "$PROJECT_ROOT/tests/test_pje_cli.sh"
    else
        echo "Nenhum teste encontrado."
    fi
}

clean_workspace() {
    echo "Limpando arquivos temporários e cache..."
    
    local cleaned=0
    
    # Remover arquivos temporários
    find "$PROJECT_ROOT" -name "*.tmp" -type f -delete 2>/dev/null && ((cleaned++))
    find "$PROJECT_ROOT" -name "*.temp" -type f -delete 2>/dev/null && ((cleaned++))
    find "$PROJECT_ROOT" -name "*~" -type f -delete 2>/dev/null && ((cleaned++))
    
    # Remover diretórios de build (se existirem e estiverem vazios)
    [ -d "$PROJECT_ROOT/build" ] && [ -z "$(ls -A $PROJECT_ROOT/build 2>/dev/null)" ] && rmdir "$PROJECT_ROOT/build" 2>/dev/null && ((cleaned++))
    
    echo "Limpeza concluída. $cleaned itens removidos."
}

check_code_quality() {
    echo "Verificando qualidade do código..."
    
    local issues=0
    
    # Verificar sintaxe de todos os arquivos .sh
    echo "Verificando sintaxe dos arquivos Bash..."
    while IFS= read -r -d '' file; do
        if bash -n "$file" 2>/dev/null; then
            echo "✓ $file"
        else
            echo "✗ Erro de sintaxe em $file"
            ((issues++))
        fi
    done < <(find "$PROJECT_ROOT" -name "*.sh" -print0)
    
    # Verificar se existem ferramentas de qualidade (shellcheck)
    if command -v shellcheck &> /dev/null; then
        echo "Verificando estilo com shellcheck..."
        shellcheck "$PROJECT_ROOT/src/pje_cli.sh" 2>/dev/null | while read -r line; do
            echo "⚠ $line"
            ((issues++))
        done
    else
        echo "ℹ shellcheck não encontrado (recomendado para verificações de estilo)"
    fi
    
    if [ $issues -eq 0 ]; then
        echo "✓ Nenhum problema encontrado na verificação de qualidade"
    else
        echo "✗ Foram encontrados $issues problema(s) de qualidade"
    fi
}

case "${1:-help}" in
    backup)
        backup_work
        ;;
    setup)
        setup_environment
        ;;
    validate)
        validate_environment
        ;;
    test)
        run_tests
        ;;
    clean)
        clean_workspace
        ;;
    check-quality|quality)
        check_code_quality
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Comando desconhecido: $1"
        echo ""
        show_help
        exit 1
        ;;
esac