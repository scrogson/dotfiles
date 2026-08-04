#!/usr/bin/env bash

# WezTerm reads the system appearance natively via wezterm.gui.get_appearance(),
# but only config.color_scheme's *load-time* value follows it. When macOS flips
# appearance on a schedule, WezTerm does not always reload its config, so the
# background stays on the old scheme while the tab bar (redrawn every second)
# switches. Touching the config file forces the reload.

MODE=$(~/.dotfiles/scripts/theme-mode.sh)
CONFIG="$HOME/.dotfiles/config/wezterm/wezterm.lua"

if [ -f "$CONFIG" ]; then
    touch "$CONFIG"
    echo "WezTerm theme: $MODE mode (config reload triggered)"
else
    echo "WezTerm theme: config not found at $CONFIG" >&2
fi
