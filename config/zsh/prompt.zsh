setopt PROMPT_SUBST

function git_prompt() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "(%F{red}${ref#refs/heads/}%F{blue})"
}

PROMPT='
%B%F{blue}[%m %~]$(git_prompt)
%b%F{white}λ$reset_color '
