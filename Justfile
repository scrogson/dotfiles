# Symlink dotfiles
link:
    env RCRC=~/.dotfiles/rcrc rcup
    mkdir -p ~/Library/Application\ Support/lazygit
    ln -sf ~/.dotfiles/config/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
    mkdir -p ~/.config/bat
    ln -sf ~/.dotfiles/config/bat/themes ~/.config/bat/themes
    bat cache --build
    @echo "✓ Dotfiles linked successfully"

# Install and load the macOS theme watcher launch agent
theme-watcher:
    mkdir -p ~/Library/LaunchAgents
    ln -sf ~/.dotfiles/config/launchd/com.user.theme-watcher.plist ~/Library/LaunchAgents/com.user.theme-watcher.plist
    -launchctl bootout gui/$(id -u)/com.user.theme-watcher 2>/dev/null
    launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.user.theme-watcher.plist
    @echo "✓ Theme watcher loaded"