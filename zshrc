PATH="/usr/local/bin:$PATH"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/local/mysql/bin:$PATH"
PATH="./node_modules/.bin:$PATH"
PATH="$HOME/.bin:$PATH"

export GREP_OPTIONS='--color=auto'
export EDITOR=nvim

source $HOME/.dotfiles/config/zsh/prompt.zsh

unsetopt correct_all

[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

eval "$(direnv hook zsh)"
fpath=(/usr/local/share/zsh-completions $fpath)
