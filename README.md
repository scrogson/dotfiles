# Dotfiles

<img max-width="1440" alt="screenshot" src="https://github.com/scrogson/dotfiles/assets/53274/fa256567-63c6-4f1e-86c4-66c1c6913589">

## Install

On a fresh machine — no clone needed, the script clones itself:

```sh
curl -fsSL https://raw.githubusercontent.com/scrogson/dotfiles/master/install.sh -o /tmp/dotfiles-install.sh && sh /tmp/dotfiles-install.sh
```

Downloading first rather than `curl | sh` keeps stdin a TTY, so Homebrew stays
interactive and `sudo`/`chsh` can prompt normally.

This installs Homebrew, runs `brew bundle`, links the dotfiles, syncs Neovim
plugins, loads the theme watcher, and switches the shell to fish.

Afterwards, swap the remote to SSH so you can push:

```sh
git -C ~/.dotfiles remote set-url origin git@github.com:scrogson/dotfiles
```

## Common tasks

```sh
just link            # re-link dotfiles (rcup + lazygit/bat extras)
just theme-watcher   # install/reload the light-dark theme launch agent
```

See [THEME_SWITCHING.md](THEME_SWITCHING.md) for how automatic light/dark
switching works, and [wezterm.md](wezterm.md) for the terminal setup.

### macOS system settings

`scripts/macos/` captures user-level macOS preferences on the old Mac and
re-applies them on the new one — see its [README](scripts/macos/README.md).
