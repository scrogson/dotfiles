function zj
    set -l layout_file "layout.kdl"
    set -l args $argv
    set -l session_name (basename (pwd))

    if test -f $layout_file
        set args $args --new-session-with-layout $layout_file
    end

    if command zellij list-sessions --short 2>/dev/null | grep -q -E "^$session_name\$"
        command zellij attach $session_name
    else
        command zellij --session $session_name $args
    end
end
