#!/bin/bash
# Updates Zellij theme and status bar colors based on system appearance

DOTFILES_DIR="$HOME/.dotfiles"
THEME_MODE=$($DOTFILES_DIR/scripts/theme-mode.sh)
ZELLIJ_CONFIG="$DOTFILES_DIR/config/zellij/config.kdl"
ZELLIJ_TEMP="$DOTFILES_DIR/config/zellij/config.kdl.tmp"
ZELLIJ_THEMES_DIR="$HOME/.config/zellij/themes"

if [ "$THEME_MODE" = "dark" ]; then
    THEME_NAME="github-dark-dimmed"
    ZJSTATUS_CONFIG="$DOTFILES_DIR/config/zellij/zjstatus-dark.kdl"
    THEME_FILE="$DOTFILES_DIR/config/zellij/themes/github-dark-dimmed.kdl"
else
    THEME_NAME="github-light"
    ZJSTATUS_CONFIG="$DOTFILES_DIR/config/zellij/zjstatus-light.kdl"
    THEME_FILE="$DOTFILES_DIR/config/zellij/themes/github-light.kdl"
fi

# Create themes directory if it doesn't exist
mkdir -p "$ZELLIJ_THEMES_DIR"

# Create symlink for the theme file
ln -sf "$THEME_FILE" "$ZELLIJ_THEMES_DIR/$(basename "$THEME_FILE")"

# Create a new config by:
# 1. Replace the theme line
# 2. Replace the zjstatus plugin block

# First, replace just the theme line
sed "s/^theme \".*\"/theme \"$THEME_NAME\"/" "$ZELLIJ_CONFIG" > "$ZELLIJ_TEMP"

# Then, replace the zjstatus plugin block
# Find the line with 'zjstatus location=' and replace until the closing brace
awk -v zjstatus_file="$ZJSTATUS_CONFIG" '
    /^    zjstatus location=/ {
        # Print the zjstatus config from file
        while ((getline line < zjstatus_file) > 0) {
            print line
        }
        close(zjstatus_file)
        # Skip lines until we find the closing brace
        in_zjstatus = 1
        next
    }
    in_zjstatus == 1 && /^    }/ {
        in_zjstatus = 0
        next
    }
    in_zjstatus == 0 {
        print
    }
' "$ZELLIJ_TEMP" > "$ZELLIJ_CONFIG.new"

mv "$ZELLIJ_CONFIG.new" "$ZELLIJ_CONFIG"
rm -f "$ZELLIJ_TEMP"

# Reload Zellij configuration if Zellij is running
if pgrep -x "zellij" > /dev/null; then
    # Get all running Zellij sessions and reload their configs
    zellij list-sessions 2>/dev/null | awk '{print $1}' | while read -r session; do
        zellij action reload-config --session "$session" 2>/dev/null || true
    done
fi
