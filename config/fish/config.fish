source ~/.asdf/asdf.fish
source ~/.asdf/completions/asdf.fish

set PATH /usr/local/bin $PATH
set PATH /opt/homebrew/bin $PATH
set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/.bin $PATH
set PATH $HOME/solana/bin $PATH

eval (direnv hook fish)

set -x SSH_AUTH_SOCK (gpgconf --list-dir agent-ssh-socket)
set -x EDITOR nvim
set -x ERL_AFLAGS "-kernel shell_history enabled"
set -x KERL_CONFIGURE_OPTIONS "--without-javac --disable-hipe --with-ssl=/opt/homebrew/opt/openssl@1.1"
set -x CFLAGS "-O2 -g -fno-stack-check -Wno-error=implicit-function-declaration"
# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/* !target"'
