#!/bin/bash
# Master script to update all application themes based on system appearance

DOTFILES_DIR="$HOME/.dotfiles"

# Update Git theme
$DOTFILES_DIR/scripts/git-theme.sh

# Update k9s theme
$DOTFILES_DIR/scripts/k9s-theme.sh

# Update Fish shell theme
$DOTFILES_DIR/scripts/fish-theme.sh

# WezTerm needs no script — config/wezterm/wezterm.lua re-applies the color
# scheme from its status-bar callback whenever the appearance changes.

echo "Themes updated based on system appearance: $($DOTFILES_DIR/scripts/theme-mode.sh)"
