# (Github Light) Colors for Fish shell
set -l comment 57606a

# Shell highlight groups
# (https://fishshell.com/docs/current/interactive.html#variables-color)

set -g fish_color_normal 24292f  # Default text
set -g fish_color_command 24292f  # 'cd', 'ls', 'echo'
# set -g fish_color_keyword cf222e  # 'if'   NOTE: default = $fish_color_command
set -g fish_color_quote 0a3069  # "foo" in 'echo "foo"'
# set -g fish_color_redirection 8250df  # '>/dev/null'   NOTE: default = magenta
# set -g fish_color_end 0550ae  # ; in 'cmd1; cmd2'   NOTE: default = blue
# set -g fish_color_error cf222e  # incomplete / non-existent commands   NOTE: default = red
set -g fish_color_param 0550ae  # xvf in 'tar xvf', --all in 'ls --all'
set -g fish_color_comment $comment  # '# a comment'
# set -g fish_color_selection --background=d0d7de
set -g fish_color_operator cf222e  # * in 'ls ./*'
# set -g fish_color_escape 0a3069  # ▆ in 'echo ▆' NOTE: default = cyan
set -g fish_color_autosuggestion $comment  # Appended virtual text
# set -g fish_color_search_match --background=d0d7de

set -g fish_pager_color_completion $fish_color_param # List of suggested items for 'ls <Tab>'
set -g fish_pager_color_description 116329  # (command) in list of commands for 'c<Tab>'
set -g fish_pager_color_prefix cf222e --underline  # Leading 'c' in list of completions for 'c<Tab>'
set -g fish_pager_color_progress 24292f  # '…and nn more rows' for 'c<Tab>'
set -g fish_pager_color_selected_background --background=d0d7de # Cursor when <Tab>ing through 'ls <Tab>'
