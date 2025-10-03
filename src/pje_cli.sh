#!/usr/bin/env bash

# PJE CLI Assistant - Um assistente de linha de comando para o PJE
# Versão: 0.1.0
# Descrição: Ferramenta para consultar e gerenciar processos judiciais via API do PJE

# Função para detectar o sistema operacional
detectar_sistema() {
    case "$(uname -s)" in
        Linux*)     echo "Linux";;
        Darwin*)    echo "Mac";;
        CYGWIN*|MINGW*|MSYS*) echo "Windows";;
        *)          echo "Desconhecido";;
    esac
}

# Função para abrir URLs no navegador padrão (multiplataforma)
abrir_navegador() {
    local url="$1"
    local sistema
    sistema=$(detectar_sistema)
    
    case "$sistema" in
        Linux*)     xdg-open "$url" 2>/dev/null || echo "Não foi possível abrir o navegador (xdg-open não disponível)";;
        Mac*)       open "$url" 2>/dev/null || echo "Não foi possível abrir o navegador (open não disponível)";;
        Windows*)   cmd /c start "" "$url" 2>/dev/null || start "$url" 2>/dev/null || echo "Não foi possível abrir o navegador";;
        *)          echo "Sistema operacional não suportado para abrir URLs";;
    esac
}

# Função para verificar dependências
verificar_dependencias() {
    local deps=("curl" "jq")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo "ERRO: As seguintes dependências não foram encontradas: ${missing[*]}"
        echo "Por favor, instale-as antes de continuar."
        exit 1
    fi
}

# Função para carregar configurações
carregar_configuracoes() {
    local config_file="./src/config/pje.conf"
    
    if [ ! -f "$config_file" ]; then
        echo "ERRO: Arquivo de configuração '$config_file' não encontrado."
        echo "Por favor, crie o arquivo com base no exemplo em src/config/pje.conf.example"
        exit 1
    fi
    
    # Carrega as variáveis do arquivo de configuração
    source "$config_file"
    
    # Validação das variáveis
    if [ -z "$NOME_ADV" ] || [ -z "$NUMERO_OAB" ] || [ -z "$UF_OAB" ]; then
        echo "ERRO: As variáveis de configuração estão incompletas."
        echo "Verifique o arquivo $config_file"
        exit 1
    fi
    
    # Codifica o nome para URL (substitui espaços por %20)
    NOME_ADV_ENCODED=$(echo "$NOME_ADV" | sed 's/ /%20/g')
}

# Função para consultar e selecionar processo
consultar_e_selecionar_processo() {
    clear
    echo "Buscando processos..."
    
    # Faz a requisição para a API
    local response
    response=$(curl -s -G \
        --data-urlencode "numeroOab=$NUMERO_OAB" \
        --data-urlencode "ufOab=$UF_OAB" \
        --data-urlencode "nomeAdvogado=$NOME_ADV_ENCODED" \
        "https://comunicaapi.pje.jus.br/api/v1/comunicacao")
    
    # Verifica se a requisição foi bem-sucedida
    if [ $? -ne 0 ]; then
        echo "ERRO: Não foi possível conectar à API do PJE."
        read -p "Pressione Enter para continuar..."
        return
    fi
    
    # Verifica se a resposta contém o campo 'items'
    local count
    count=$(echo "$response" | jq -r '.count // 0')
    
    if [ "$count" -eq 0 ]; then
        echo "Nenhum processo encontrado para este advogado."
        read -p "Pressione Enter para continuar..."
        return
    fi
    
    # Extrai e exibe os processos únicos
    local processos
    processos=$(echo "$response" | jq -r '.items[].numero_processo' | sort -u)
    
    echo "Foram encontrados os seguintes processos:"
    echo ""
    
    # Converte a lista de processos em array
    local processo_array=()
    while IFS= read -r processo; do
        if [ -n "$processo" ]; then
            processo_array+=("$processo")
        fi
    done < <(echo "$processos")
    
    # Exibe a lista numerada
    for i in "${!processo_array[@]}"; do
        echo "$((i+1))) ${processo_array[$i]}"
    done
    
    echo ""
    echo "q) Sair"
    echo ""
    
    # Lê a escolha do usuário
    while true; do
        read -p "Escolha um processo (1-${#processo_array[@]}) ou 'q' para sair: " escolha
        
        if [ "$escolha" = "q" ] || [ "$escolha" = "Q" ]; then
            exit 0
        fi
        
        # Verifica se a entrada é um número válido
        if ! [[ "$escolha" =~ ^[0-9]+$ ]]; then
            echo "Opção inválida. Por favor, insira um número."
            continue
        fi
        
        # Verifica se está dentro do intervalo
        if [ "$escolha" -lt 1 ] || [ "$escolha" -gt "${#processo_array[@]}" ]; then
            echo "Opção inválida. Por favor, insira um número entre 1 e ${#processo_array[@]}."
            continue
        fi
        
        # Processo selecionado
        local processo_selecionado="${processo_array[$((escolha-1))]}"
        exibir_historico_e_acoes "$processo_selecionado"
        break
    done
}

# Função para exibir histórico de andamentos
exibir_historico_e_acoes() {
    local numero_processo="$1"
    clear
    echo "Buscando histórico para o processo $numero_processo..."
    
    # Faz a requisição para a API com o número do processo
    local response
    response=$(curl -s -G \
        --data-urlencode "numeroProcesso=$numero_processo" \
        "https://comunicaapi.pje.jus.br/api/v1/comunicacao")
    
    # Verifica se a requisição foi bem-sucedida
    if [ $? -ne 0 ]; then
        echo "ERRO: Não foi possível conectar à API do PJE."
        read -p "Pressione Enter para continuar..."
        return
    fi
    
    # Extrai e exibe as comunicações
    local comunicacoes
    comunicacoes=$(echo "$response" | jq -r '.items | sort_by(.data_disponibilizacao) | .[] | "\(.data_disponibilizacao)|\(.tipoComunicacao)|\(.hash)|\(.id)"')
    
    # Armazena comunicações em arrays
    local datas=()
    local tipos=()
    local hashes=()
    local ids=()
    
    while IFS='|' read -r data tipo hash id; do
        datas+=("$data")
        tipos+=("$tipo")
        hashes+=("$hash")
        ids+=("$id")
    done < <(echo "$comunicacoes")
    
    if [ ${#datas[@]} -eq 0 ]; then
        echo "Nenhuma comunicação encontrada para este processo."
        read -p "Pressione Enter para continuar..."
        return
    fi
    
    # Exibe a lista numerada
    for i in "${!datas[@]}"; do
        echo "$((i+1))) ${datas[$i]} - ${tipos[$i]}"
    done
    
    echo ""
    echo "v) Voltar"
    echo ""
    
    # Lê a escolha do usuário
    while true; do
        read -p "Escolha uma comunicação (1-${#datas[@]}) ou 'v' para voltar: " escolha
        
        if [ "$escolha" = "v" ] || [ "$escolha" = "V" ]; then
            return
        fi
        
        # Verifica se a entrada é um número válido
        if ! [[ "$escolha" =~ ^[0-9]+$ ]]; then
            echo "Opção inválida. Por favor, insira um número."
            continue
        fi
        
        # Verifica se está dentro do intervalo
        if [ "$escolha" -lt 1 ] || [ "$escolha" -gt "${#datas[@]}" ]; then
            echo "Opção inválida. Por favor, insira um número entre 1 e ${#datas[@]}."
            continue
        fi
        
        # Comunicação selecionada
        local idx=$((escolha-1))
        menu_acoes "${hashes[$idx]}" "$numero_processo" "${tipos[$idx]}" "${datas[$idx]}"
        break
    done
}

# Função para exibir menu de ações
menu_acoes() {
    local hash="$1"
    local numero_processo="$2"
    local tipo_comunicacao="$3"
    local data_comunicacao="$4"
    
    while true; do
        clear
        echo "Processo: $numero_processo"
        echo "Comunicação: $tipo_comunicacao"
        echo "Data: $data_comunicacao"
        echo ""
        echo "Escolha uma ação:"
        echo "a) Abrir no navegador"
        echo "b) Baixar PDF"
        echo "v) Voltar para o histórico"
        echo ""
        
        read -p "Opção: " opcao
        
        case "$opcao" in
            a|A)
                local url="https://comunicaapi.pje.jus.br/api/v1/comunicacao/$hash/certidao"
                echo "Abrindo no navegador..."
                abrir_navegador "$url"
                read -p "Pressione Enter para continuar..."
                ;;
            b|B)
                local url="https://comunicaapi.pje.jus.br/api/v1/comunicacao/$hash/certidao"
                local nome_arquivo="${numero_processo}_${hash}.pdf"
                echo "Baixando PDF como '$nome_arquivo'..."
                curl -L -o "$nome_arquivo" "$url"
                if [ $? -eq 0 ]; then
                    echo "PDF baixado com sucesso!"
                else
                    echo "Erro ao baixar o PDF."
                fi
                read -p "Pressione Enter para continuar..."
                ;;
            v|V)
                return
                ;;
            *)
                echo "Opção inválida."
                read -p "Pressione Enter para continuar..."
                ;;
        esac
    done
}

# Função principal
main() {
    echo "PJE CLI Assistant v0.1.0"
    echo "Iniciando..."
    
    verificar_dependencias
    carregar_configuracoes
    
    while true; do
        consultar_e_selecionar_processo
    done
}

# Executa a função principal se este script for executado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main
fi