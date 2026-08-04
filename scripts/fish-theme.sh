#!/usr/bin/env bash

# Fish colors live in universal variables, which fish syncs to every running
# shell. Sourcing the palette from any fish process therefore recolors shells
# that are already open — no restart, no re-source. This is why the theme files
# use `set -U` rather than `set -g`.

# Run from launchd, where PATH is bare and Homebrew is not on it.
FISH=$(command -v fish || echo /opt/homebrew/bin/fish)

MODE=$(~/.dotfiles/scripts/theme-mode.sh)

if [ "$MODE" = "dark" ]; then
    THEME=github_dark_dimmed
else
    THEME=github_light
fi

if "$FISH" -c "source ~/.config/fish/$THEME.fish"; then
    echo "Fish theme switched to $MODE mode ($THEME)"
else
    echo "Fish theme: failed to source ~/.config/fish/$THEME.fish" >&2
    exit 1
fi
