#!/usr/bin/env bash

# Get the current macOS appearance mode
MODE=$(~/.dotfiles/scripts/theme-mode.sh)

DOTFILES_DIR="$HOME/.dotfiles"
K9S_CONFIG="$DOTFILES_DIR/config/k9s/config.yaml"
K9S_SKINS_DIR="$HOME/Library/Application Support/k9s/skins"

# Ensure skins directory exists
mkdir -p "$K9S_SKINS_DIR"

# Create symlinks to dotfiles skins
ln -sf "$DOTFILES_DIR/config/k9s/skins/github-dark-dimmed.yaml" "$K9S_SKINS_DIR/github-dark-dimmed.yaml"
ln -sf "$DOTFILES_DIR/config/k9s/skins/github-light.yaml" "$K9S_SKINS_DIR/github-light.yaml"

# Determine which skin to use
if [ "$MODE" = "dark" ]; then
    SKIN_NAME="github-dark-dimmed"
else
    SKIN_NAME="github-light"
fi

# Check if config file exists
if [ ! -f "$K9S_CONFIG" ]; then
    echo "k9s config not found. Please run k9s once to generate the config file."
    exit 1
fi

# Update or add the skin setting in the ui: section
if grep -q "^    skin:" "$K9S_CONFIG"; then
    # Skin line exists, update it
    sed -i.bak "s/^    skin:.*/    skin: $SKIN_NAME/" "$K9S_CONFIG"
else
    # No skin line, add it under ui: section
    sed -i.bak "/^    useFullGVRTitle:/a\\
    skin: $SKIN_NAME
" "$K9S_CONFIG"
fi

rm -f "$K9S_CONFIG.bak"

echo "k9s theme switched to $MODE mode ($SKIN_NAME)"