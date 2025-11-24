#!/bin/bash
# Master script to update all application themes based on system appearance

DOTFILES_DIR="$HOME/.dotfiles"

# Update Alacritty theme
$DOTFILES_DIR/scripts/alacritty-theme.sh

# Update Zellij theme
$DOTFILES_DIR/scripts/zellij-theme.sh

# Update Git theme
$DOTFILES_DIR/scripts/git-theme.sh

# Update k9s theme
$DOTFILES_DIR/scripts/k9s-theme.sh

# Reload Alacritty config (if running)
# Alacritty automatically reloads with live_config_reload = true

echo "Themes updated based on system appearance: $($DOTFILES_DIR/scripts/theme-mode.sh)"
