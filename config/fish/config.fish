set -x EDITOR nvim
set -x ERL_FLAGS "-kernel shell_history enabled -kernel standard_io_encoding utf8"
set -x KERL_CONFIGURE_OPTIONS --with-ssl=/opt/homebrew/opt/openssl/ --with-wx-config=/opt/homebrew/opt/wxwidgets/bin/wx-config --without-javac --without-odbc
set -x SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# Completions are autoloaded from $fish_complete_path — no sourcing needed.
# The old explicit `source .../completions/*.fish` lines errored on every shell
# start when the glob matched nothing (e.g. before Homebrew links fish).

# Clear universal fish_user_paths to prevent stale entries
set -e -U fish_user_paths

# Theme colors are universal variables, so the theme watcher
# (scripts/fish-theme.sh) recolors every running shell when the system
# appearance changes. They persist across sessions; this only bootstraps a
# shell that has never had a theme applied.
if not set -q __theme_mode
    if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark
        source ~/.config/fish/github_dark_dimmed.fish
    else
        source ~/.config/fish/github_light.fish
    end
end

set -q KREW_ROOT; and set -gx PATH $PATH $KREW_ROOT/.krew/bin; or set -gx PATH $PATH $HOME/.krew/bin

# mise (tool version manager)
mise activate fish | source

# Ensure priority paths come first (after mise modifies PATH)
fish_add_path -gPm \
    $HOME/.local/bin \
    $HOME/.bin \
    $HOME/.cargo/bin \
    /opt/homebrew/opt/openssl@1.1/bin \
    /opt/homebrew/bin

starship init fish | source
