#!/bin/bash
# Returns "dark" or "light" based on the system appearance.
#
# macOS: the global AppleInterfaceStyle default.
# Linux: the freedesktop color-scheme preference, which Omarchy sets on every
# theme switch (omarchy-theme-set-gnome) and which WezTerm reads via the portal.

case "$(uname -s)" in
  Darwin)
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q "Dark"; then
        echo "dark"
    else
        echo "light"
    fi
    ;;
  *)
    if gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null | grep -q "light"; then
        echo "light"
    else
        echo "dark"
    fi
    ;;
esac
