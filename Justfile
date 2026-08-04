# Symlink dotfiles
link:
    env RCRC=~/.dotfiles/rcrc rcup
    mkdir -p ~/Library/Application\ Support/lazygit
    ln -sf ~/.dotfiles/config/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
    mkdir -p ~/.config/bat
    ln -sf ~/.dotfiles/config/bat/themes ~/.config/bat/themes
    bat cache --build
    ./scripts/git-theme.sh
    @echo "✓ Dotfiles linked successfully"

# Install and load the macOS theme watcher launch agent
theme-watcher:
    mkdir -p ~/Library/LaunchAgents
    ln -sf ~/.dotfiles/config/launchd/com.user.theme-watcher.plist ~/Library/LaunchAgents/com.user.theme-watcher.plist
    -launchctl bootout gui/$(id -u)/com.user.theme-watcher 2>/dev/null
    launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.theme-watcher.plist
    @echo "✓ Theme watcher loaded"

# Remap Caps Lock to Control via a launch agent (survives reboot)
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