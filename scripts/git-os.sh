#!/usr/bin/env bash

# Points config/git/config-os at the settings for this OS. Like config-theme,
# the symlink is machine state, so it is generated and gitignored.

case "$(uname -s)" in
  Darwin) TARGET=config-darwin ;;
  *) TARGET=config-linux ;;
esac

ln -sfn "$TARGET" "$HOME/.dotfiles/config/git/config-os"
echo "Git OS config linked ($TARGET)"
