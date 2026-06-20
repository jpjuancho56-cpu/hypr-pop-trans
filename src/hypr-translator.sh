#!/usr/bin/env bash

# Colores para la interfaz en la terminal
HYPR_TRANS_BLUE="\e[1;34m"
HYPR_TRANS_GREEN="\e[1;32m"
HYPR_TRANS_GRAY="\e[2m"
ENDCOLOR="\e[0m"

export LONG_TRANSLATION_THRESHOLD=50
export DETAILED_TRANSLATION_THRESHOLD=4

# Función interna que procesa y dibuja la traducción
hypr_trans_handle_clipboard() {
    local current_text="$1"
    local detected_language
    local word_count
    local normalized_text

    # Evitar procesar si el texto está vacío o son solo espacios
    if [[ -z "${current_text// }" ]]; then
        return
    fi

    # Limpiar la ventana para el nuevo contenido
    clear

    normalized_text=$(
        printf '%s' "$current_text" |
        tr '_' ' '
    )
    
    word_count=$(
        printf '%s' "$current_text" |
        tr '_-' '  ' |
        wc -w
    )
    echo -e "cantidad de palabras: ${word_count}"
    
    detected_language=$(
        trans -no-ansi -identify "$current_text" |
        awk '/^Code/ {print tolower($2)}' |
        cut -d'-' -f1
    )

    # Cabecera estética
    echo -e "${HYPR_TRANS_BLUE}✨ hypr-translate (Modo Reactivo) ✨${ENDCOLOR}"
    echo -e "${HYPR_TRANS_GRAY}Selecciona cualquier texto para traducir en tiempo real...${ENDCOLOR}"
    echo -e "${HYPR_TRANS_GRAY}--------------------------------------------------${ENDCOLOR}\n"

    # Si el texto es largo no mostramos el texto original solo la traducción
    if ((word_count < LONG_TRANSLATION_THRESHOLD)); then
        # Mostrar Texto Original
        echo -e "${HYPR_TRANS_BLUE}📝 Original:${ENDCOLOR}"
        echo -e "$current_text"
    fi

    # Mostrar Traducción
    echo -e "${HYPR_TRANS_GREEN}🌐 Traducción (Español):${ENDCOLOR}"       
    translate_text "$normalized_text" "$detected_language" "$word_count"
    echo ""
}

translate_text() {
    local text="$1"
    local language="$2"
    local word_count="$3"

    local source_target
    local trans_args=()

    if [[ "$language" == "en" ]]; then
        source_target="en:es"
    else
        # Si detecta inglés (en), traducimos estrictamente a español (:es)
        source_target="es:en"
    fi

    if ((word_count > DETAILED_TRANSLATION_THRESHOLD)); then
        trans_args+=("-brief")
    else 
        trans_args+=("-show-languages" "n" "-show-original" "n")
    fi
    
    trans "${trans_args[@]}" "$source_target" "$text"
}

# --- BUCLE DE ESCUCHA a (WAYLAND) ---

# Limpieza inicial de la pantalla
clear
echo -e "${HYPR_TRANS_BLUE}🚀 Iniciando escucha del portapapeles...${ENDCOLOR}"
echo -e "${HYPR_TRANS_GRAY}Selecciona o copia algún texto para empezar.${ENDCOLOR}"

export -f hypr_trans_handle_clipboard
export HYPR_TRANS_BLUE HYPR_TRANS_GREEN HYPR_TRANS_GRAY ENDCOLOR
export -f translate_text
export LONG_TRANSLATION_THRESHOLD
export DETAILED_TRANSLATION_THRESHOLD

# wl-paste --watch ejecuta una función cada vez que el portapapeles cambia.
# Escuchar el portapapeles y procesarlo
wl-paste --type text/plain --watch bash -c '
    clipboard_text=$(cat)
    hypr_trans_handle_clipboard "$clipboard_text"
'