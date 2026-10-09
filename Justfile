# Symlink dotfiles
link: _link-os
    ./scripts/git-theme.sh
    ./scripts/git-os.sh
    @echo "✓ Dotfiles linked successfully"

[macos]
_link-os:
    env RCRC=~/.dotfiles/rcrc rcup
    mkdir -p ~/Library/Application\ Support/lazygit
    ln -sf ~/.dotfiles/config/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
    mkdir -p ~/.config/bat
    ln -sf ~/.dotfiles/config/bat/themes ~/.config/bat/themes
    bat cache --build

# rcup -f: Omarchy ships its own nvim/git/lazygit/starship configs; install.sh
# backs those up first. rcup links config/bat/themes on its own here.
[linux]
_link-os:
    env RCRC=~/.dotfiles/rcrc rcup -f
    bat cache --build

# Install and load the macOS theme watcher launch agent
[macos]
theme-watcher:
    mkdir -p ~/Library/LaunchAgents
    ln -sf ~/.dotfiles/config/launchd/com.user.theme-watcher.plist ~/Library/LaunchAgents/com.user.theme-watcher.plist
    -launchctl bootout gui/$(id -u)/com.user.theme-watcher 2>/dev/null
    launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.theme-watcher.plist
    @echo "✓ Theme watcher loaded"

# Omarchy has no appearance to poll — it runs theme-set hooks on every theme
# switch, after updating the color-scheme preference theme-mode.sh reads.
[linux]
theme-watcher:
    mkdir -p ~/.config/omarchy/hooks/theme-set.d
    ln -sf ~/.dotfiles/config/omarchy/hooks/theme-set.d/dotfiles-themes ~/.config/omarchy/hooks/theme-set.d/dotfiles-themes
    ./scripts/update-themes.sh
    @echo "✓ Omarchy theme-set hook installed"

# Remap Caps Lock to Control via a launch agent (survives reboot)
[macos]
caps-to-control:
    mkdir -p ~/Library/LaunchAgents
    ln -sf ~/.dotfiles/config/launchd/com.user.caps-to-control.plist ~/Library/LaunchAgents/com.user.caps-to-control.plist
    -launchctl bootout gui/$(id -u)/com.user.caps-to-control 2>/dev/null
    launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.caps-to-control.plist
    @echo "✓ Caps Lock remapped to Control"

# Back up ~/.claude to an external volume (default: ENIGMA)
backup-claude volume="/Volumes/ENIGMA":
    ~/.dotfiles/scripts/backup-claude.sh {{volume}}

# Restore ~/.claude from an external volume (default: ENIGMA)
restore-claude volume="/Volumes/ENIGMA":
    ~/.dotfiles/scripts/restore-claude.sh {{volume}}
