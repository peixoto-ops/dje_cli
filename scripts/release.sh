#!/usr/bin/env bash

# Script de automação de releases para PJE CLI Assistant
# Este script automatiza o processo de criação de releases e tags

set -e  # Sai se algum comando falhar

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
VERSION_FILE="$PROJECT_ROOT/VERSION"

show_help() {
    echo "Script de automação de releases para PJE CLI Assistant"
    echo ""
    echo "Uso: $0 [major|minor|patch|pre] [alpha|beta|rc]"
    echo ""
    echo "Comandos:"
    echo "  major              - Cria uma nova versão major (quebra compatibilidade)"
    echo "  minor              - Cria uma nova versão minor (adiciona funcionalidades)"
    echo "  patch              - Cria uma nova versão patch (corrige bugs)"
    echo "  pre [alpha|beta|rc] - Cria uma pré-versão"
    echo "  current            - Mostra a versão atual"
    echo "  help               - Mostra esta mensagem"
    echo ""
    echo "Exemplos:"
    echo "  $0 patch           - Cria uma nova versão patch"
    echo "  $0 pre alpha       - Cria uma nova versão alpha"
    echo "  $0 minor           - Cria uma nova versão minor"
}

get_current_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "0.0.0"
    fi
}

validate_version_format() {
    local version="$1"
    if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z]+\.[0-9]+)?$ ]]; then
        echo "Erro: Formato de versão inválido: $version"
        return 1
    fi
}

increment_version() {
    local version="$1"
    local part="$2"
    
    local major minor patch prerelease prerelease_number
    
    if [[ $version =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)(-[a-zA-Z]+\.([0-9]+))?$ ]]; then
        major="${BASH_REMATCH[1]}"
        minor="${BASH_REMATCH[2]}"
        patch="${BASH_REMATCH[3]}"
        prerelease="${BASH_REMATCH[4]}"
        prerelease_number="${BASH_REMATCH[5]}"
    else
        echo "Erro: Não foi possível interpretar a versão: $version"
        return 1
    fi
    
    case "$part" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            prerelease=""
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            prerelease=""
            ;;
        patch)
            patch=$((patch + 1))
            prerelease=""
            ;;
        pre)
            if [ -n "$prerelease" ]; then
                # Se já há uma pré-versão, incrementa o número
                prerelease_number=$((prerelease_number + 1))
                patch="$patch"
            else
                # Se não há pré-versão, começa com .1
                prerelease_number=1
            fi
            # Precisamos obter o tipo de pré-versão do próximo argumento
            prerelease_type="${3}"
            if [ -z "$prerelease_type" ]; then
                echo "Erro: Tipo de pré-versão necessário (alpha, beta, rc)"
                return 1
            fi
            prerelease="-$prerelease_type.$prerelease_number"
            ;;
    esac
    
    if [ -n "$prerelease" ]; then
        echo "${major}.${minor}.${patch}${prerelease}"
    else
        echo "${major}.${minor}.${patch}"
    fi
}

create_release() {
    local new_version="$1"
    local release_type="$2"
    local prerelease_type="$3"
    
    validate_version_format "$new_version" || exit 1
    
    echo "Preparando release: $new_version"
    
    # Verificar se há mudanças não commitadas
    if ! git diff-index --quiet HEAD --; then
        echo "AVISO: Você tem mudanças não commitadas!"
        read -p "Deseja continuar mesmo assim? (s/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Ss]$ ]]; then
            echo "Operação cancelada."
            exit 1
        fi
    fi
    
    # Verificar se os testes estão passando (se existirem)
    if [ -f "$PROJECT_ROOT/tests/test_pje_cli.sh" ]; then
        echo "Executando testes antes de criar a release..."
        if bash "$PROJECT_ROOT/tests/test_pje_cli.sh"; then
            echo "✓ Testes passaram"
        else
            echo "✗ Testes falharam - abortando release"
            exit 1
        fi
    fi
    
    # Atualizar o arquivo VERSION
    echo "$new_version" > "$VERSION_FILE"
    echo "Versão atualizada para $new_version"
    
    # Adicionar o arquivo VERSION ao commit
    git add "$VERSION_FILE"
    
    # Criar commit com a mudança de versão
    local commit_msg="build: release $new_version"
    if [ "$release_type" = "pre" ]; then
        commit_msg="build: pre-release $new_version"
    fi
    
    git commit -m "$commit_msg"
    
    # Criar tag
    local tag_name="v$new_version"
    git tag -a "$tag_name" -m "Release version $new_version"
    
    echo "Tag criada: $tag_name"
    
    # Gerar ou atualizar changelog (simulação)
    local changelog_entry="# Version $new_version ($(date +%Y-%m-%d))
    
## Mudanças desta versão:
- Atualize este changelog com base nos commits desde a última versão

## Tipo de Mudança:
- $(if [ "$release_type" = "major" ]; then echo "Breaking changes"; elif [ "$release_type" = "minor" ]; then echo "Novas funcionalidades"; else echo "Correções de bugs"; fi)
"
    
    # Adicionar ao CHANGELOG
    if [ -f "$PROJECT_ROOT/CHANGELOG.md" ]; then
        sed -i.bak "1s/^/$changelog_entry\n/" "$PROJECT_ROOT/CHANGELOG.md"
        rm "$PROJECT_ROOT/CHANGELOG.md.bak"
    else
        echo "$changelog_entry" > "$PROJECT_ROOT/CHANGELOG.md"
    fi
    
    echo "Release $new_version criada com sucesso!"
    echo "Lembre-se de fazer push das alterações e da tag:"
    echo "  git push origin main"
    echo "  git push origin $tag_name"
}

case "${1:-help}" in
    major)
        local current=$(get_current_version)
        local new_version=$(increment_version "$current" "major")
        create_release "$new_version" "major"
        ;;
    
    minor)
        local current=$(get_current_version)
        local new_version=$(increment_version "$current" "minor")
        create_release "$new_version" "minor"
        ;;
    
    patch)
        local current=$(get_current_version)
        local new_version=$(increment_version "$current" "patch")
        create_release "$new_version" "patch"
        ;;
    
    pre)
        if [ -z "$2" ]; then
            echo "Erro: Tipo de pré-versão necessário (alpha, beta, rc)"
            echo ""
            show_help
            exit 1
        fi
        
        local prerelease_type="$2"
        if [[ ! "$prerelease_type" =~ ^(alpha|beta|rc)$ ]]; then
            echo "Erro: Tipo de pré-versão inválido. Use: alpha, beta ou rc"
            exit 1
        fi
        
        local current=$(get_current_version)
        local new_version=$(increment_version "$current" "pre" "$prerelease_type")
        create_release "$new_version" "pre" "$prerelease_type"
        ;;
    
    current)
        echo "Versão atual: $(get_current_version)"
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