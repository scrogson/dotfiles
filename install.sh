#!/bin/sh

#######################################################
# install.sh
# This script sets up a laptop the way that I like it.
#######################################################

set -e

DOTFILES="$HOME/.dotfiles"

puts() {
  local fmt="$1"; shift

  printf "\n$fmt\n" "$@"
}

asdf_install() {
  if [ ! -d "~/.asdf/installs/$1" ]; then
    puts "Installing $1..."
    asdf list-all $1 | tail -1 | xargs asdf install $1
  fi
}

if ! command -v brew >/dev/null; then
  puts "Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap homebrew/bundle
fi

if [ ! -d "$HOME/.cargo" ]; then
  puts "Installing rust toolchain..."
  curl https://sh.rustup.rs -sSf | sh
fi

if ! command -v git >/dev/null; then
  brew install git
fi

if [ ! -d "$HOME/.asdf" ]; then
  puts "Installing asdf..."
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf
fi

if [ ! -d "$DOTFILES" ]; then
  puts "Cloning dotfiles..."
  git clone https://github.com/scrogson/dotfiles ~/.dotfiles
fi

puts "Updating Homebrew..."
brew update
brew bundle --file=$DOTFILES/Brewfile

puts "Linking dotfiles..."
RCRC=$DOTFILES/rcrc rcup

if ! [ -e ~/.config/nvim/autoload/plug.vim ]; then
  puts "Installing vim-plug..."
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  puts "Installing vim plugins..."
  nvim +PlugInstall +qall
fi

source $HOME/.asdf/asdf.sh

if ! asdf plugin-list | grep elixir > /dev/null; then
  puts "Installing elixir asdf plugin..."
  asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
fi

if ! asdf plugin-list | grep erlang > /dev/null; then
  puts "Installing erlang asdf plugin..."
  asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
fi

if ! asdf plugin-list | grep node > /dev/null; then
  puts "Installing node asdf plugin..."
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
fi

if ! asdf plugin-list | grep ruby > /dev/null; then
  puts "Installing ruby asdf plugin..."
  asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
fi

asdf_install erlang
asdf_install elixir
asdf_install nodejs
asdf_install ruby

if ! grep -Fxq "$(which fish)" /etc/shells; then
  puts "Adding fish to list of shells"
  echo "$(which fish)" | sudo tee -a /etc/shells
fi

case "$SHELL" in
  */fish) : ;;
  *)
    puts "Changing SHELL to fish..."
      chsh -s "$(which fish)"
    ;;
esac
