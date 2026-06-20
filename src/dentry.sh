#!/usr/bin/env bash

# Set .desktop DIR
APP_DIR="$HOME/.local/share/applications"
# Set icon DIR
ICON_DIR="$HOME/.local/share/applications/icons"

echo "=== dentry (.desktop generator) ==="
echo ""

read -rp "App Name: " NAME

# fzf based file selector
echo ""
echo "Select file to create (type to search):"
echo ""

FILE_PATH=$(find "$HOME" -type f 2>/dev/null \
  | fzf --height 40% --border --prompt="File > ")

if [[ -z "$FILE_PATH" || ! -f "$FILE_PATH" ]]; then
    echo "No valid file selected."
    exit 1
fi

echo "Selected: $FILE_PATH"

read -rp "Icon Name: " ICON_INPUT
read -rp "Terminal (true/false): " TERMINAL
read -rp "Categories: " CATEGORIES
read -rp "Comment: " COMMENT

TERMINAL=${TERMINAL:-false}
CATEGORIES=${CATEGORIES:-""}
COMMENT=${COMMENT:-""}

mkdir -p "$APP_DIR"
mkdir -p "$ICON_DIR"

# .jar | .sh | .AppImage detection
EXEC=""

if [[ "$FILE_PATH" == *.jar ]]; then
    EXEC="java -jar $FILE_PATH"

elif [[ "$FILE_PATH" == *.sh ]]; then
    EXEC="bash $FILE_PATH"

elif [[ "$FILE_PATH" == *.AppImage ]]; then
    chmod +x "$FILE_PATH" 2>/dev/null
    EXEC="$FILE_PATH"

else
    EXEC="$FILE_PATH"
fi

# Icon handling
while true; do
    if [[ "$ICON_INPUT" != *.* ]]; then
        echo "Extension not recognized. Please include a valid extension."
        read -rp "Icon Name: " ICON_INPUT
        continue
    fi

    ICON_PATH="$ICON_DIR/$ICON_INPUT"
    break
done

if [[ -f "$ICON_PATH" ]]; then
    ICON="$(realpath "$ICON_PATH")"
else
    ICON="$ICON_PATH"
fi

# File name
DESKTOP_NAME=$(echo "$NAME" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/[^a-z0-9]/-/g' \
  | sed 's/^-*//; s/-*$//')

DESKTOP_FILE="$APP_DIR/$DESKTOP_NAME.desktop"

# Overwrite if exists
[[ -f "$DESKTOP_FILE" ]] && rm "$DESKTOP_FILE"

# Create .desktop file
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=$NAME
Exec=$EXEC
Icon=$ICON
Terminal=$TERMINAL
Categories=$CATEGORIES
Comment=$COMMENT
EOF

chmod +x "$DESKTOP_FILE"

echo ""
echo "Created: $DESKTOP_FILE"
