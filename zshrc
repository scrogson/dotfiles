# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

DISABLE_AUTO_TITLE=true
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git vundle)

source $ZSH/oh-my-zsh.sh
unsetopt correct_all

export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad

source "`brew --prefix`/etc/grc.bashrc"


# Customize to your needs...

# Color shortcuts
RED=$fg[red]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
BLACK=$fg[black]
RED_BOLD=$fg_bold[red]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
RESET_COLOR=$reset_color

# get the name of the current ruby and gemset
function rvm_prompt() {
  if [ -f ~/.rvm/bin/rvm-prompt ] ; then
	  rvm_ruby=$(~/.rvm/bin/rvm-prompt v g 2> /dev/null) || return
    echo "(%{$RED_BOLD%}${rvm_ruby}%{$RESET_COLOR%})"
  fi
}

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$RED_BOLD%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$RED%}unmerged"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$RED%}deleted"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$YELLOW%}renamed"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$YELLOW%}modified"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$GREEN%}added"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$WHITE%}untracked"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$RED%}(!)"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$WHITE%}[%{$YELLOW%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$WHITE%}]"

# Prompt format
PROMPT='
%{$BLUE_BOLD%}[%m ${PWD/#$HOME/~}]$(parse_git_dirty)
%{$WHITE%}$%{$RESET_COLOR%} '
RPROMPT='$(rvm_prompt) %{$GREEN_BOLD%}$(current_branch)$(git_prompt_short_sha)$(git_prompt_status)%{$RESET_COLOR%}'

# Set Environment Paths
EDITOR=vim

PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
PATH="/usr/local/bin:$PATH"
PATH="/usr/local/share/python:$PATH"
PATH="./node_modules/.bin:$PATH"

NODE_PATH="/usr/local/lib/node_modules"

alias tmux="TERM=screen-256color-bce tmux"

# RVM
if [[ -s $HOME/.rvm/scripts/rvm ]] ; then source $HOME/.rvm/scripts/rvm ; fi

# Tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# use .zshrc.local for settings specific to one system
[[ -f $HOME/.zshrc.local ]] && . $HOME/.zshrc.local
