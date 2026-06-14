#!/usr/bin/env bash

# Colores para una salida bonita en la terminal (estilo HyDE)
GREEN="\e[1;32m"
BLUE="\e[1;34m"
YELLOW="\e[1;33m"
CYAN="\e[1;36m"
ENDCOLOR="\e[0m"

echo -e "${BLUE}🚀 Iniciando la instalación de hypr-pop-trans...${ENDCOLOR}"

# 1. Crear el directorio de binarios locales si no existe
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

# 2. Copiar el script principal y darle permisos
echo -e "${CYAN}📁 Copiando el script a $BIN_DIR...${ENDCOLOR}"
cp src/hypr-translator.sh "$BIN_DIR/hypr-translator"
chmod +x "$BIN_DIR/hypr-translator"

# ==============================================================================
# 3. Configuración de Window Rules
# ==============================================================================
HYPR_WINDOWRULES="$HOME/.config/hypr/windowrules.conf"

if [ -f "$HYPR_WINDOWRULES" ]; then
    # Verificar si ya existe la configuración para evitar duplicados
    if grep -q "hypr-translator" "$HYPR_WINDOWRULES"; then
        echo -e "${YELLOW}⚠️ Ya se detectó una configuración previa en windowrule.conf. No se modificará.${ENDCOLOR}"
    else
        echo -e "${CYAN}📝 Añadiendo reglas de ventana y keybindings a windowrule.conf...${ENDCOLOR}"
        
        # Escribir la configuración al final del archivo
        cat << 'EOF' >> "$HYPR_WINDOWRULES"

# --- CONFIGURACIÓN PARA HYPR-POP-TRANS ---
# Define las reglas de comportamiento para la ventana flotante de Kitty
windowrule = float true, class:^(hypr-translator)$
windowrule = size 450 600, class:^(hypr-translator)$
windowrule = move 74% 4%, class:^(hypr-translator)$
windowrule = sticky, class:^(hypr-translator)$
windowrule = pin, class:^(hypr-translator)$

# ----------------------------------------
EOF
        echo -e "${GREEN}✅ Window Rules inyectadas con éxito en windowrules.conf.${ENDCOLOR}"
    fi
else
    echo -e "${YELLOW}⚠️ No se encontró windowrules.conf en la ruta estándar.${ENDCOLOR}"
fi

# ==============================================================================
# 4. Configuración de Keybindings
# ==============================================================================

HYPER_KEYBINDINGS="$HOME/.config/hypr/keybindings.conf"

if [ -f "$HYPER_KEYBINDINGS" ]; then
   if grep -q "hypr-translator" "$HYPER_KEYBINDINGS"; then
        echo -e "${YELLOW} ⚠️ Ya se detectó una configuración previa en keybindings.conf. No se modificará.${ENDCOLOR}"
    else
        echo -e "${CYAN}📝 Añadiendo atajos de teclado a keybindings.conf...${ENDCOLOR}"
        cat << 'EOF' >> "$HYPER_KEYBINDINGS"

# --- CONFIG TO HYPR-POP-TRANS ---

# Atajo de teclado: SUPER + ALT + T (Abre la ventana con Kitty)
bind = $mainMod ALT, T, exec, kitty --class hypr-translator -o window_padding_width=15 -e ~/.local/bin/hypr-translator
# ----------------------------------------
EOF
echo -e "${GREEN}✅ Keybindings inyectados con éxito en keybindings.conf.${ENDCOLOR}"
    fi
else
    echo -e "${YELLOW}⚠️ No se encontró keybindings.conf en la ruta estándar.${ENDCOLOR}"
fi

echo -e "${GREEN}🎉 ¡Instalación completada! Recarga Hyprland y presiona SUPER + ALT + T para probarlo.${ENDCOLOR}"