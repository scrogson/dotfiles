# Use `hub` as git wrapper:
# http://defunkt.github.com/hub
hub_path=$(which hub)
if (( $+commands[hub] ))
then
  alias git=$hub_path
fi
