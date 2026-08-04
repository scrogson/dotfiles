#!/usr/bin/env bash

# Points config/git/config-theme at the dark or light delta config. The symlink
# is generated (and gitignored) rather than tracked: it is machine state, so a
# tracked copy went stale on every appearance switch and carried a hardcoded
# home directory from whichever machine committed it last. The target is
# relative so the link stays valid wherever the repo is checked out.
#
# config/git/config includes it by path; git silently ignores the include when
# it does not exist, so a fresh clone works before this script has ever run.

MODE=$(~/.dotfiles/scripts/theme-mode.sh)

CONFIG_THEME="$HOME/.dotfiles/config/git/config-theme"

if [ "$MODE" = "dark" ]; then
    TARGET=config-dark
else
    TARGET=config-light
fi

ln -sfn "$TARGET" "$CONFIG_THEME"
echo "Git theme switched to $MODE mode"
