#!/bin/bash
# Updates Alacritty theme import based on system appearance

DOTFILES_DIR="$HOME/.dotfiles"
THEME_MODE=$($DOTFILES_DIR/scripts/theme-mode.sh)
ALACRITTY_CONFIG="$DOTFILES_DIR/config/alacritty/alacritty.toml"
ALACRITTY_TEMP="$DOTFILES_DIR/config/alacritty/alacritty.toml.tmp"

if [ "$THEME_MODE" = "dark" ]; then
    THEME_FILE="dimmed.toml"
else
    THEME_FILE="light.toml"
fi

# Replace the github theme file in the import array (handles multi-line imports)
if [ "$THEME_MODE" = "dark" ]; then
    sed 's/light\.toml/dimmed.toml/g' "$ALACRITTY_CONFIG" > "$ALACRITTY_TEMP"
else
    sed 's/dimmed\.toml/light.toml/g' "$ALACRITTY_CONFIG" > "$ALACRITTY_TEMP"
fi
mv "$ALACRITTY_TEMP" "$ALACRITTY_CONFIG"

echo "Alacritty theme switched to $THEME_MODE mode"
