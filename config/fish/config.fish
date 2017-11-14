set -x EDITOR nvim
set -x GREP_OPTIONS "--color=auto"
set -x ERL_AFLAGS "-kernel shell_history enabled"

set PATH /usr/local/bin $PATH
set PATH $HOME/.cargo/bin $PATH
set PATH $HOME/.bin $PATH
set PATH ./bin $PATH
set PATH ./node_modules/.bin $PATH

source ~/.asdf/asdf.fish
source ~/.asdf/completions/asdf.fish

eval (direnv hook fish)
