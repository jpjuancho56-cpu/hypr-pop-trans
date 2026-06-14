#!/usr/bin/env bash

# Colores para la interfaz en la terminal
HYPR_TRANS_BLUE="\e[1;34m"
HYPR_TRANS_GREEN="\e[1;32m"
HYPR_TRANS_GRAY="\e[2m"
ENDCOLOR="\e[0m"

# Función interna que procesa y dibuja la traducción
hypr_trans_handle_clipboard() {
    local current_text="$1"

    # Evitar procesar si el texto está vacío o son solo espacios
    if [[ -z "${current_text// }" ]]; then
        return
    fi

    # Limpiar la ventana para el nuevo contenido
    clear

    # Cabecera estética
    echo -e "${HYPR_TRANS_BLUE}✨ hypr-translate (Modo Reactivo) ✨${ENDCOLOR}"
    echo -e "${HYPR_TRANS_GRAY}Selecciona cualquier texto para traducir en tiempo real...${ENDCOLOR}"
    echo -e "${HYPR_TRANS_GRAY}--------------------------------------------------${ENDCOLOR}\n"

    # Mostrar Texto Original
    echo -e "${HYPR_TRANS_BLUE}📝 Original:${ENDCOLOR}"
    echo -e "$current_text"
    echo ""

    # Mostrar Traducción
    echo -e "${HYPR_TRANS_GREEN}🌐 Traducción (Español):${ENDCOLOR}"
    # trans :es hace la traducción rápida al español
    trans -brief :es "$current_text"
    echo ""
}

# --- BUCLE DE ESCUCHA ACTIVA (WAYLAND) ---

# Limpieza inicial de la pantalla
clear
echo -e "${HYPR_TRANS_BLUE}🚀 Iniciando escucha del portapapeles...${ENDCOLOR}"
echo -e "${HYPR_TRANS_GRAY}Selecciona o copia algún texto para empezar.${ENDCOLOR}"

# wl-paste --watch ejecuta una función cada vez que el portapapeles cambia.
# Usamos 'pipe' para pasarle el contenido copiado directamente a nuestra función.
export -f hypr_trans_handle_clipboard
export HYPR_TRANS_BLUE HYPR_TRANS_GREEN HYPR_TRANS_GRAY ENDCOLOR

# Escuchar tanto la selección primaria (resaltar texto) como el portapapeles normal (Ctrl+C)
# Usamos un bucle while leyendo el flujo de wl-paste de forma continua
wl-paste --type text/plain --watch bash -c 'hypr_trans_handle_clipboard "$(wl-paste)"'