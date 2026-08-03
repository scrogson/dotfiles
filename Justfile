# Symlink dotfiles
link:
    env RCRC=~/.dotfiles/rcrc rcup
    mkdir -p ~/Library/Application\ Support/lazygit
    ln -sf ~/.dotfiles/config/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
    mkdir -p ~/.config/bat
    ln -sf ~/.dotfiles/config/bat/themes ~/.config/bat/themes
    bat cache --build
    @echo "✓ Dotfiles linked successfully"