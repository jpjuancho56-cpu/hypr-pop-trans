#!/usr/bin/env bash

# Colores para una salida bonita en la terminal (estilo HyDE)
GREEN="\e[1;32m"
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
CYAN="\e[1;36m"
ENDCOLOR="\e[0m"
DIM="\e[2m"

# Obtener el texto seleccionado actualmente (portapapeles primario de Wayland)
TEXTO=$(wl-paste -p)

# Si la selección primaria está vacía, intentar con el portapapeles normal
if [ -z "$TEXTO" ]; then
    TEXTO=$(wl-paste)
fi

# Si sigue vacío, mostrar un mensaje amigable
if [ -z "$TEXTO" ]; then
    echo "No hay texto seleccionado."
    sleep 2
    exit 0
fi

# Limpiar pantalla y ejecutar la traducción (de inglés a español en este ejemplo)
clear
echo -e "${BLUE}--- Texto Original ---${ENDCOLOR}"
echo "$TEXTO"
echo -e "${GREEN}--- Traducción ---${ENDCOLOR}"

# trans :es hace la traducción al español. 
# Puedes cambiarlo a tu gusto (ej. en:ja, es:en)
trans -brief :es "$TEXTO"

# Mantener la ventana abierta hasta que presiones una tecla (o puedes quitar esto si prefieres)
echo ""
echo -e "${DIM}Presiona cualquier tecla para cerrar...${ENDCOLOR}"
read -n 1