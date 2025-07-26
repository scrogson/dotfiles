set -x EDITOR nvim
set -x ERL_FLAGS "-kernel shell_history enabled"
set -x KERL_CONFIGURE_OPTIONS --with-ssl=/opt/homebrew/opt/openssl/ --with-wx-config=/opt/homebrew/opt/wxwidgets/bin/wx-config --without-javac --without-odbc

source /opt/homebrew/share/fish/completions/*.fish
source /opt/homebrew/share/fish/vendor_completions.d/*.fish

# Clear user paths
set -U fish_user_paths

# Base system paths
set PATH /usr/bin /bin /usr/sbin /sbin

# Add custom paths, avoiding duplicates
for dir in /usr/local/bin /opt/homebrew/bin $HOME/.cargo/bin $HOME/.bin
    if not contains $dir $PATH
        set -p PATH $dir
    end
end

# Final deduplication
set PATH (string split " " $PATH | uniq)

fish_add_path /opt/homebrew/opt/openssl@1.1/bin
fish_add_path "$HOME/.fvm/bin" "$HOME/.fluvio/bin"

# ASDF configuration code
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

# Do not use fish_add_path (added in Fish 3.2) because it
# potentially changes the order of items in PATH
if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end

set --erase _asdf_shims

# Source external configs
source ~/.config/fish/github_dark_dimmed.fish
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

eval (direnv hook fish)
starship init fish | source
