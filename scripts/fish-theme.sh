#!/usr/bin/env bash

# Fish theme is auto-detected in config.fish on shell startup.
# New shells will pick up the correct theme automatically.
# This script exists for consistency with the theme-watcher pipeline.

MODE=$(~/.dotfiles/scripts/theme-mode.sh)
echo "Fish theme: $MODE mode (new shells will auto-detect)"
