#!/bin/bash
# Returns "dark" or "light" based on macOS system appearance

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q "Dark"; then
    echo "dark"
else
    echo "light"
fi
