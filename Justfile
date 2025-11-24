# Symlink dotfiles
link:
    env RCRC=~/.dotfiles/rcrc rcup
    mkdir -p ~/Library/Application\ Support/lazygit
    ln -sf ~/.dotfiles/config/lazygit/config.yml ~/Library/Application\ Support/lazygit/config.yml
    @echo "✓ Dotfiles linked successfully"