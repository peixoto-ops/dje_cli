#!/usr/bin/env bash

# Script auxiliar para gerenciamento de branches
# Este script facilita a criação de branches seguindo as políticas do projeto

show_help() {
    echo "Script de Gerenciamento de Branches para PJE CLI Assistant"
    echo ""
    echo "Uso: $0 [comando] [argumentos]"
    echo ""
    echo "Comandos:"
    echo "  feature <nome>     - Cria uma nova branch de feature a partir de 'develop'"
    echo "  release <versao>   - Cria uma nova branch de release a partir de 'develop'"
    echo "  hotfix <versao>    - Cria uma nova branch de hotfix a partir de 'main'"
    echo "  sync-develop       - Atualiza a branch 'develop' com as alterações de 'main'"
    echo "  list               - Lista as branches locais e remotas"
    echo "  help               - Mostra esta mensagem"
    echo ""
    echo "Exemplos:"
    echo "  $0 feature adicionar-menu"
    echo "  $0 release v1.2.0"
    echo "  $0 hotfix v1.1.1"
}

case "${1:-help}" in
    feature)
        if [ -z "$2" ]; then
            echo "Erro: Nome da feature é necessário"
            echo ""
            show_help
            exit 1
        fi
        
        # Verificar se estamos no branch develop
        current_branch=$(git branch --show-current)
        if [ "$current_branch" != "develop" ]; then
            echo "AVISO: Você não está no branch 'develop'. Atualize antes de criar a feature."
            read -p "Deseja continuar mesmo assim? (s/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Ss]$ ]]; then
                echo "Operação cancelada."
                exit 1
            fi
        fi
        
        git checkout -b "feature/$2" develop
        echo "Branch 'feature/$2' criada a partir de 'develop'"
        ;;
    
    release)
        if [ -z "$2" ]; then
            echo "Erro: Número da versão é necessário"
            echo ""
            show_help
            exit 1
        fi
        
        # Verificar se estamos no branch develop
        current_branch=$(git branch --show-current)
        if [ "$current_branch" != "develop" ]; then
            echo "Erro: Você deve estar no branch 'develop' para criar uma release"
            exit 1
        fi
        
        git checkout -b "release/$2" develop
        echo "Branch 'release/$2' criada a partir de 'develop'"
        ;;
    
    hotfix)
        if [ -z "$2" ]; then
            echo "Erro: Número da versão é necessário"
            echo ""
            show_help
            exit 1
        fi
        
        # Verificar se estamos no branch main
        current_branch=$(git branch --show-current)
        if [ "$current_branch" != "main" ]; then
            echo "Erro: Você deve estar no branch 'main' para criar um hotfix"
            exit 1
        fi
        
        git checkout -b "hotfix/$2" main
        echo "Branch 'hotfix/$2' criada a partir de 'main'"
        ;;
    
    sync-develop)
        echo "Atualizando branch 'develop' com alterações de 'main'..."
        git checkout main
        git pull origin main
        git checkout develop
        git pull origin develop
        git merge main
        echo "Branch 'develop' atualizada com alterações de 'main'"
        ;;
    
    list)
        echo "Branches locais:"
        git branch
        echo ""
        echo "Branches remotas:"
        git branch -r
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