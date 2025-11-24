#!/bin/bash
# Watches for macOS appearance changes and updates themes

DOTFILES_DIR="$HOME/.dotfiles"
LAST_MODE=""

while true; do
    CURRENT_MODE=$($DOTFILES_DIR/scripts/theme-mode.sh)

    if [ "$CURRENT_MODE" != "$LAST_MODE" ]; then
        echo "Appearance changed to: $CURRENT_MODE"
        $DOTFILES_DIR/scripts/update-themes.sh
        LAST_MODE="$CURRENT_MODE"
    fi

    sleep 5
done
