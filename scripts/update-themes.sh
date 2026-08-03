#!/bin/bash
# Master script to update all application themes based on system appearance

DOTFILES_DIR="$HOME/.dotfiles"

# Update Git theme
$DOTFILES_DIR/scripts/git-theme.sh

# Update k9s theme
$DOTFILES_DIR/scripts/k9s-theme.sh

# Update Fish shell theme
$DOTFILES_DIR/scripts/fish-theme.sh

# WezTerm needs no script — it reads the system appearance natively via
# wezterm.gui.get_appearance() (see config/wezterm/theme.lua).

echo "Themes updated based on system appearance: $($DOTFILES_DIR/scripts/theme-mode.sh)"
