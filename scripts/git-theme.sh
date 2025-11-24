#!/usr/bin/env bash

# Get the current macOS appearance mode
MODE=$(~/.dotfiles/scripts/theme-mode.sh)

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_THEME="$DOTFILES_DIR/config/git/config-theme"

if [ "$MODE" = "dark" ]; then
    ln -sf "$DOTFILES_DIR/config/git/config-dark" "$CONFIG_THEME"
    echo "Git theme switched to dark mode"
else
    ln -sf "$DOTFILES_DIR/config/git/config-light" "$CONFIG_THEME"
    echo "Git theme switched to light mode"
fi