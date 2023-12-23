function zj
    set -l layout_file "layout.kdl"
    set -l args $argv
    set -l session_name (basename (pwd))

    # Check for layout file
    if test -f $layout_file
        set args $args -l $layout_file
    end

    # Check if a session with the current directory name already exists
    if zellij list-sessions | grep -q $session_name
        # Attach to the existing session
        command zellij attach $session_name
    else
        # Create a new session with additional arguments
        set args $args --session $session_name
        command zellij $args
    end
end
