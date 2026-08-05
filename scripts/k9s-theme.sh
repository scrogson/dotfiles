#!/usr/bin/env bash

# Points k9s at the dark or light skin.
#
# k9s looks for its config in $K9S_CONFIG_DIR, falling back to the platform
# config dir — on macOS that is ~/Library/Application Support/k9s, NOT
# ~/.config/k9s. The repo used to carry a config.yaml symlinked to the latter,
# so writing the skin there had no effect: k9s never read the file and stayed on
# its built-in dark skin regardless of the system appearance. Only the skins are
# tracked now; k9s owns its config and rewrites it on exit.

MODE=$(~/.dotfiles/scripts/theme-mode.sh)

DOTFILES_DIR="$HOME/.dotfiles"

if [ -n "$K9S_CONFIG_DIR" ]; then
    K9S_DIR="$K9S_CONFIG_DIR"
elif [ "$(uname -s)" = "Darwin" ]; then
    K9S_DIR="$HOME/Library/Application Support/k9s"
else
    K9S_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/k9s"
fi

K9S_CONFIG="$K9S_DIR/config.yaml"
K9S_SKINS_DIR="$K9S_DIR/skins"

mkdir -p "$K9S_SKINS_DIR"
ln -sf "$DOTFILES_DIR/config/k9s/skins/github-dark-dimmed.yaml" "$K9S_SKINS_DIR/github-dark-dimmed.yaml"
ln -sf "$DOTFILES_DIR/config/k9s/skins/github-light.yaml" "$K9S_SKINS_DIR/github-light.yaml"

if [ "$MODE" = "dark" ]; then
    SKIN_NAME="github-dark-dimmed"
else
    SKIN_NAME="github-light"
fi

if [ ! -f "$K9S_CONFIG" ]; then
    echo "k9s config not found at $K9S_CONFIG. Run k9s once to generate it." >&2
    exit 1
fi

if grep -q "^    skin:" "$K9S_CONFIG"; then
    sed -i.bak "s/^    skin:.*/    skin: $SKIN_NAME/" "$K9S_CONFIG"
elif grep -q "^  ui:" "$K9S_CONFIG"; then
    # k9s rewrites this file itself and omits the key when unset, so put it back
    # directly under ui: rather than anchoring on a sibling that may not exist.
    sed -i.bak "/^  ui:/a\\
    skin: $SKIN_NAME
" "$K9S_CONFIG"
else
    echo "k9s config at $K9S_CONFIG has no ui: section; leaving it alone." >&2
    exit 1
fi

rm -f "$K9S_CONFIG.bak"

echo "k9s theme switched to $MODE mode ($SKIN_NAME)"
