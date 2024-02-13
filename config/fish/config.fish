set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/.foundry/bin $PATH
set PATH $HOME/.bin $PATH
set PATH /usr/local/bin $PATH
set PATH /opt/homebrew/bin $PATH
set PATH /opt/homebrew/opt/coreutils/libexec/gnubin $PATH
set PATH /opt/homebrew/opt/gnu-getopt/bin $PATH

source ~/.asdf/asdf.fish
source ~/.asdf/completions/asdf.fish
source /opt/homebrew/share/fish/completions/*.fish
source /opt/homebrew/share/fish/vendor_completions.d/*.fish

eval (direnv hook fish)

# set -x SSH_AUTH_SOCK (gpgconf --list-dir agent-ssh-socket)
set -x EDITOR nvim

fish_add_path /opt/homebrew/opt/openssl@1.1/bin

# pnpm
set -gx PNPM_HOME "/Users/scrogson/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

starship init fish | source

source ~/.config/fish/github_dark_dimmed.fish

source ~/.config/fish/completions/zellij.fish
for file in ~/.config/fish/completions/*.fish
    source $file
end
