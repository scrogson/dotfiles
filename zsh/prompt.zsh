autoload colors && colors

function git_prompt() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "(%{$fg[red]%}${ref#refs/heads/}%{$fg[blue]%})"
}

precmd() {
# Prompt format
PROMPT='
%{$fg_bold[blue]%}[%m ${PWD/#$HOME/~}]$(git_prompt)
%{$fg[white]%}λ%{$reset_color%} '
}

# vim: ft=zsh tw=2 ts=2 noet
