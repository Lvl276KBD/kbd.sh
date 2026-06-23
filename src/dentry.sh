#!/usr/bin/env bash

# Set .desktop DIR
APP_DIR="${APP_DIR:-$HOME/.local/share/applications}"
# Set icon DIR  
ICON_DIR="${ICON_DIR:-$HOME/.local/share/applications/icons}"

# Exit handling
trap 'echo -e "\nScript interrupted." >&2; exit 1' INT TERM ERR

echo "--❤︎ dentry (.desktop file generator) ❤︎--"
echo ""

# Website or File handling
echo "Select creation type:"
echo "1. File"
echo "2. Website"
read -rp "Enter choice (1 or 2): " CHOICE

case "$CHOICE" in
    1)
        CREATE_WEBSITE=false
        ;;
    2)
        CREATE_WEBSITE=true
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Website handling
if [[ "$CREATE_WEBSITE" == true ]]; then
    read -rp "Website URL: " WEBSITE_URL
    if [[ -z "$WEBSITE_URL" ]]; then
        echo "Error: Website URL cannot be empty."
        exit 1
    fi
    
    # Validate URL
    if ! [[ "$WEBSITE_URL" =~ ^https?:// ]]; then
        echo "Warning: URL doesn't appear to be valid. Proceeding anyway..."
    fi
    
    read -rp "App Name: " NAME
    if [[ -z "$NAME" ]]; then
        echo "Error: App Name cannot be empty."
        exit 1
    fi
    
    # Validate Icon
    while true; do
        read -rp "Icon Name: " ICON_INPUT
        if [[ -n "$ICON_INPUT" ]] && [[ "$ICON_INPUT" == *.* ]]; then
            break
        else
            echo "Error: Extension not recognized. Please include a valid extension."
        fi
    done
    
    # Validate terminal option
    while true; do
        read -rp "Terminal (true/false): " TERMINAL
        case "$TERMINAL" in
            true|false) break ;;
            *) echo "Invalid terminal value. Must be 'true' or 'false'." ;;
        esac
    done
    
    # Category / Comment inputs
    read -rp "Categories: " CATEGORIES
    CATEGORIES=${CATEGORIES:-""}
    read -rp "Comment: " COMMENT
    COMMENT=${COMMENT:-""}
    
    # Create dir. if needed
    mkdir -p "$APP_DIR"
    mkdir -p "$ICON_DIR"
    
    # Website open
    EXEC="xdg-open \"$WEBSITE_URL\""
    
    # Icon check-path
    if [[ -f "$ICON_INPUT" ]]; then
        ICON=$(realpath "$ICON_INPUT")
    elif [[ -f "$ICON_DIR/$ICON_INPUT" ]]; then
        ICON="$ICON_DIR/$ICON_INPUT"
    else
        ICON_PATH="$ICON_DIR/$ICON_INPUT"
        ICON="$ICON_PATH"
    fi
    
    # File name generation
    DESKTOP_NAME=$(echo "$NAME" \
      | tr '[:upper:]' '[:lower:]' \
      | sed 's/[^a-z0-9]/-/g' \
      | sed 's/^-*//; s/-*$//')
    
    DESKTOP_FILE="$APP_DIR/$DESKTOP_NAME.desktop"
    
    # Overwrite if exists
    [[ -f "$DESKTOP_FILE" ]] && rm "$DESKTOP_FILE"
    
    # Create .desktop file for website
    cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=$NAME
Exec=$EXEC
Icon=$ICON
Terminal=$TERMINAL
Categories=$CATEGORIES
Comment=$COMMENT
Version=1.0
EOF
    
    chmod +x "$DESKTOP_FILE"
    
    echo ""
    echo "Created: $DESKTOP_FILE"
    echo ""
    echo "=== Desktop Entry Preview ==="
    cat "$DESKTOP_FILE"
    echo "==============================="
    exit 0
fi

# Create .desktop file for file
echo ""

# Name handling
while true; do
    read -rp "App Name: " NAME
    if [[ -n "$NAME" ]]; then
        break
    else
        echo "Error: App Name cannot be empty."
    fi
done

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

# Validate Icon
while true; do
    read -rp "Icon Name: " ICON_INPUT
    if [[ -n "$ICON_INPUT" ]] && [[ "$ICON_INPUT" == *.* ]]; then
        break
    else
        echo "Error: Extension not recognized. Please include a valid extension."
    fi
done

# Validate Terminal
while true; do
    read -rp "Terminal (true/false): " TERMINAL
    case "$TERMINAL" in
        true|false) break ;;
        *) echo "Invalid terminal value. Must be 'true' or 'false'." ;;
    esac
done

# Category / Comment input
read -rp "Categories: " CATEGORIES
CATEGORIES=${CATEGORIES:-""}
read -rp "Comment: " COMMENT
COMMENT=${COMMENT:-""}

mkdir -p "$APP_DIR"
mkdir -p "$ICON_DIR"

# .jar | .sh | .AppImage | .py detection
EXEC=""

if [[ "$FILE_PATH" == *.jar ]]; then
    EXEC="java -jar \"$FILE_PATH\""

elif [[ "$FILE_PATH" == *.sh ]]; then
    EXEC="bash \"$FILE_PATH\""

elif [[ "$FILE_PATH" == *.AppImage ]]; then
    chmod +x "$FILE_PATH" 2>/dev/null
    EXEC="\"$FILE_PATH\""

elif [[ "$FILE_PATH" == *.py ]]; then
    EXEC="python3 \"$FILE_PATH\""

else
    EXEC="\"$FILE_PATH\""
fi

# Icon check-path
if [[ -f "$ICON_INPUT" ]]; then
    ICON=$(realpath "$ICON_INPUT")
elif [[ -f "$ICON_DIR/$ICON_INPUT" ]]; then
    ICON="$ICON_DIR/$ICON_INPUT"
else
    ICON_PATH="$ICON_DIR/$ICON_INPUT"
    ICON="$ICON_PATH"
fi

# Name handling
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
Version=1.0
EOF

chmod +x "$DESKTOP_FILE"

echo ""
echo "Created: $DESKTOP_FILE"
echo ""
echo "=== Desktop Entry Preview ==="
cat "$DESKTOP_FILE"
echo "==============================="
