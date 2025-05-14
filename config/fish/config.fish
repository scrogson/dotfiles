# Clear user paths
set -U fish_user_paths

# Base system paths
set PATH /usr/bin /bin /usr/sbin /sbin

# Add custom paths, avoiding duplicates
for dir in /usr/local/bin /opt/homebrew/bin $HOME/.cargo/bin $HOME/.foundry/bin $HOME/.bin
    if not contains $dir $PATH
        set -p PATH $dir
    end
end

# Source external configs
source ~/.asdf/asdf.fish
source ~/.asdf/completions/asdf.fish
source /opt/homebrew/share/fish/completions/*.fish
source /opt/homebrew/share/fish/vendor_completions.d/*.fish

# Final deduplication
set PATH (string split " " $PATH | uniq)

eval (direnv hook fish)

# set -x SSH_AUTH_SOCK (gpgconf --list-dir agent-ssh-socket)
set -x EDITOR nvim
set -x ERL_FLAGS "-kernel shell_history enabled"
set -x KERL_CONFIGURE_OPTIONS --with-ssl=/opt/homebrew/opt/openssl/ --with-wx-config=/opt/homebrew/opt/wxwidgets/bin/wx-config --without-javac --without-odbc

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
fish_add_path /Library/TeX/texbin
