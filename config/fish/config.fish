set -x SSH_AUTH_SOCK (gpgconf --list-dir agent-ssh-socket)
set -x EDITOR nvim
set -x ERL_AFLAGS "-kernel shell_history enabled"

# --files: List files that would be searched but do not search
# --no-ignore: Do not respect .gitignore, etc...
# --hidden: Search hidden files and folders
# --follow: Follow symlinks
# --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/* !target"'

set PATH /usr/local/bin $PATH
set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/.bin $PATH

source ~/.asdf/asdf.fish
source ~/.asdf/completions/asdf.fish

eval (direnv hook fish)
