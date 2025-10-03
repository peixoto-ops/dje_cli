#!/usr/bin/env bash

# Testes para o PJE CLI Assistant
# Este script contém testes básicos para verificar a funcionalidade do script principal

# Caminho para o script principal
SCRIPT_PATH="./src/pje_cli.sh"

# Função para imprimir cabeçalho de teste
print_header() {
    echo "=================================="
    echo "$1"
    echo "=================================="
}

# Função para teste de sintaxe
test_syntax() {
    print_header "Teste de Sintaxe"
    if bash -n "$SCRIPT_PATH"; then
        echo "✓ Sintaxe do script está correta"
        return 0
    else
        echo "✗ Erro de sintaxe no script"
        return 1
    fi
}

# Função para teste de dependências
test_dependencies() {
    print_header "Teste de Dependências"
    local deps=("curl" "jq")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo "✗ Dependências ausentes: ${missing[*]}"
        return 1
    else
        echo "✓ Todas as dependências estão instaladas"
        return 0
    fi
}

# Função para teste de detecção de sistema
test_os_detection() {
    print_header "Teste de Detecção de Sistema"
    
    # Testar se a função detectar_sistema existe
    if grep -q "detectar_sistema" "$SCRIPT_PATH"; then
        echo "✓ Função de detecção de sistema encontrada"
        
        # Tentar carregar e testar a função (simulação básica)
        local temp_test=$(mktemp)
        echo '#!/bin/bash' > "$temp_test"
        grep -A 20 "detectar_sistema" "$SCRIPT_PATH" >> "$temp_test"
        
        if bash -n "$temp_test"; then
            echo "✓ Função de detecção de sistema tem sintaxe válida"
            rm "$temp_test"
            return 0
        else
            echo "✗ Função de detecção de sistema tem erro de sintaxe"
            rm "$temp_test"
            return 1
        fi
    else
        echo "✗ Função de detecção de sistema não encontrada"
        return 1
    fi
}

# Função para teste de funções específicas
test_functions() {
    print_header "Teste de Funções Essenciais"
    
    local functions=("verificar_dependencias" "carregar_configuracoes" "abrir_navegador")
    local missing=()
    
    for func in "${functions[@]}"; do
        if grep -q "function $func\|${func}()" "$SCRIPT_PATH"; then
            echo "✓ Função $func encontrada"
        else
            echo "✗ Função $func NÃO encontrada"
            missing+=("$func")
        fi
    done
    
    if [ ${#missing[@]} -eq 0 ]; then
        return 0
    else
        echo "✗ Algumas funções essenciais estão ausentes"
        return 1
    fi
}

# Executar todos os testes
run_all_tests() {
    echo "Iniciando testes para PJE CLI Assistant..."
    echo ""
    
    local total_tests=4
    local passed_tests=0
    
    if test_syntax; then
        ((passed_tests++))
    fi
    echo ""
    
    if test_dependencies; then
        ((passed_tests++))
    fi
    echo ""
    
    if test_os_detection; then
        ((passed_tests++))
    fi
    echo ""
    
    if test_functions; then
        ((passed_tests++))
    fi
    echo ""
    
    print_header "RESULTADO FINAL"
    echo "Testes passados: $passed_tests/$total_tests"
    
    if [ $passed_tests -eq $total_tests ]; then
        echo "✓ Todos os testes passaram!"
        return 0
    else
        echo "✗ Alguns testes falharam"
        return 1
    fi
}

# Executar os testes se este script for chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests
fi