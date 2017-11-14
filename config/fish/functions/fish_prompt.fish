function fish_prompt
  echo "["(hostname | cut -d . -f 1) (directory_name)"]" (git_info)
  echo (promt_line)
end

function version
  if test -e mix.exs
    set_color 62A
    echo -n (elixir_version)
    set_color normal
  else if test -e package.json
    set_color yellow
    echo -n (node_version)
    set_color normal
  else if test -e Gemfile
    set_color red
    echo -n (node_version)
    set_color normal
  else
    echo -n ""
  end
end

function ruby_version
  echo (asdf which ruby)
end

function node_version
  echo (asdf which nodejs)
end

function elixir_version
  echo (asdf which elixir)
end

function git_info
  set -l repo_info (command git rev-parse --git-dir --is-inside-git-dir --is-bare-repository --is-inside-work-tree --short HEAD ^/dev/null)
  test -n "$repo_info"; or return
  set -l pristine (command git status --porcelain)
  set -l unpushed (command git cherry -v @\{origin\} ^/dev/null)
  echo -n "("
  if test "$pristine" = ""
    set_color green
    git_prompt_info
    set_color normal
  else
    set_color red
    git_prompt_info
    set_color normal
  end
  echo -n ")"

  if test "$unpushed" = ""
    echo -n ""
  else
    echo "is"
    set_color magenta
    echo -n "unpushed"
    set_color normal
  end
end

function git_prompt_info
  git symbolic-ref --quiet --short HEAD; or git show --oneline -s | awk '{print $1}'
end

function directory_name
  set_color green
  echo -n (prompt_pwd)
  # echo -n (basename $PWD)
  set_color normal
end

function promt_line
  set_color white
  echo -n "λ "
  set_color normal
end
