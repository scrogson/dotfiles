autoload colors && colors

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

precmd() {
# Prompt format
PROMPT='
%{$fg_bold[blue]%}[%m ${PWD/#$HOME/~}]${return_code}
%{$fg[white]%}λ%{$reset_color%} '
}

# vim: ft=zsh tw=2 ts=2 noet
