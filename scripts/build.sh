#!/usr/bin/env bash

# Script de build para o PJE CLI Assistant
# Este script facilita a preparação de pacotes de instalação

set -e  # Sai se algum comando falhar

# Função para exibir ajuda
show_help() {
    echo "Script de build para PJE CLI Assistant"
    echo "Uso: $0 [opção]"
    echo ""
    echo "Opções:"
    echo "  build        - Prepara um diretório para empacotamento"
    echo "  archive      - Cria um arquivo tar.gz ou zip para distribuição"
    echo "  install      - Instala o script localmente"
    echo "  help         - Exibe esta mensagem de ajuda"
    echo ""
}

# Função para obter a versão
get_version() {
    if [ -f "VERSION" ]; then
        cat VERSION
    else
        echo "0.0.0"
    fi
}

# Função de build
do_build() {
    echo "Preparando diretório de build..."
    
    # Cria diretório de build
    BUILD_DIR="build/pje-cli-assistant-$(get_version)"
    rm -rf build/
    mkdir -p "$BUILD_DIR"/{bin,config,docs,scripts}
    
    # Copia arquivos principais
    cp src/pje_cli.sh "$BUILD_DIR/bin/"
    chmod +x "$BUILD_DIR/bin/pje_cli.sh"
    
    # Copia configuração de exemplo
    cp src/config/pje.conf.example "$BUILD_DIR/config/"
    
    # Copia documentação
    cp -r docs "$BUILD_DIR/"
    
    # Copia arquivos de release
    cp {README.md,CHANGELOG.md,LICENSE} "$BUILD_DIR/" 2>/dev/null || true
    
    echo "Build completo em: $BUILD_DIR"
}

# Função para criar arquivo de distribuição
do_archive() {
    echo "Criando arquivo de distribuição..."
    
    BUILD_DIR="build/pje-cli-assistant-$(get_version)"
    if [ ! -d "$BUILD_DIR" ]; then
        echo "Diretório de build não encontrado. Execute '$0 build' primeiro."
        exit 1
    fi
    
    ARCHIVE_NAME="pje-cli-assistant-$(get_version)"
    
    # Detecta o sistema para escolher o formato de arquivo
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        # Windows - cria ZIP
        ARCHIVE_NAME="$ARCHIVE_NAME.zip"
        (cd build && zip -r "$ARCHIVE_NAME" "pje-cli-assistant-$(get_version)")
    else
        # Unix-like - cria tar.gz
        ARCHIVE_NAME="$ARCHIVE_NAME.tar.gz"
        (cd build && tar -czf "$ARCHIVE_NAME" "pje-cli-assistant-$(get_version)")
    fi
    
    echo "Arquivo de distribuição criado: build/$ARCHIVE_NAME"
}

# Função para instalar localmente
do_install() {
    echo "Instalando localmente..."
    
    # Determina o diretório de instalação
    if [ -w "/usr/local/bin" ]; then
        INSTALL_DIR="/usr/local/bin"
        CONFIG_DIR="/usr/local/etc/pje"
    else
        INSTALL_DIR="$HOME/bin"
        CONFIG_DIR="$HOME/.config/pje"
        mkdir -p "$INSTALL_DIR"
    fi
    
    # Copia o script
    cp src/pje_cli.sh "$INSTALL_DIR/"
    chmod +x "$INSTALL_DIR/pje_cli.sh"
    
    # Cria diretório de configuração
    mkdir -p "$CONFIG_DIR"
    
    # Copia configuração de exemplo se não existir
    if [ ! -f "$CONFIG_DIR/pje.conf" ]; then
        cp src/config/pje.conf.example "$CONFIG_DIR/pje.conf"
        echo "Arquivo de configuração criado em: $CONFIG_DIR/pje.conf"
        echo "Por favor, edite com seus dados antes de usar o script."
    fi
    
    echo "Instalação concluída em: $INSTALL_DIR"
    echo "Para usar o script, execute: pje_cli.sh"
}

# Verifica argumentos
case "${1:-build}" in
    build)
        do_build
        ;;
    archive)
        do_archive
        ;;
    install)
        do_install
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        echo "Opção desconhecida: $1"
        echo "Use '$0 help' para obter ajuda."
        exit 1
        ;;
esac