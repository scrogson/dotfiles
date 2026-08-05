# Automatic Theme Switching Setup

This setup automatically switches themes for WezTerm, Neovim, Git, k9s, and Fish
based on your macOS system appearance (light/dark mode).

## How It Works

1. **Theme Detection**: `scripts/theme-mode.sh` detects the current macOS appearance
2. **WezTerm**: Reads the system appearance natively and re-applies the scheme
   from its status-bar callback — no script involved
3. **Neovim**: Switches between `github_dark_dimmed` and `github_light` on focus/startup
   - **Lualine status bar**: Automatically updates to match the theme
4. **Git**: Repoints a `config-theme` symlink at the dark or light delta config
5. **k9s**: Swaps the active skin
6. **Fish**: Colors are universal variables, so already-running shells recolor

## Files

```
.dotfiles/
├── scripts/
│   ├── theme-mode.sh          # Detects macOS appearance (dark/light)
│   ├── git-theme.sh           # Repoints config/git/config-theme
│   ├── k9s-theme.sh           # Swaps the k9s skin
│   ├── fish-theme.sh          # Recolors running fish shells
│   ├── update-themes.sh       # Master script to update all themes
│   └── theme-watcher.sh       # Background process to watch for changes
├── config/
│   ├── git/
│   │   ├── config-dark        # Dark delta/diff colors
│   │   └── config-light       # Light delta/diff colors
│   ├── k9s/skins/             # k9s skins (the config is k9s's own, untracked)
│   ├── wezterm/theme.lua      # Native appearance detection
│   ├── fish/functions/
│   │   └── update-themes.fish # Fish function for manual updates
│   └── launchd/
│       └── com.user.theme-watcher.plist  # Launch agent
└── config/nvim/lua/scrogson/plugins/
    ├── colorscheme.lua        # Updated with auto-detection
    └── lualine.lua            # Updated to sync with colorscheme
```

## Setup Instructions

### 1. Run Initial Theme Update

```bash
~/.dotfiles/scripts/update-themes.sh
```

### 2. Enable Automatic Theme Switching

```bash
just theme-watcher
```

This symlinks the launch agent into `~/Library/LaunchAgents/` and bootstraps it.
The recipe is re-runnable — it boots out any existing copy first. `install.sh`
runs it for you on a new machine.

### 3. Neovim Setup

Neovim will automatically detect the theme on:
- Startup
- When gaining focus (FocusGained event)

No additional setup needed - it works automatically!

### 4. Manual Theme Update

You can manually trigger a theme update anytime:

```bash
# Using the Fish function
update-themes

# Or directly
~/.dotfiles/scripts/update-themes.sh
```

## How Each Application Works

### WezTerm
- **Auto-detection**: Native, via `wezterm.gui.get_appearance()`
- **Configuration**: `config/wezterm/theme.lua`
- **Update**: `config.color_scheme` and the tab bar colors are only read when
  the config loads, and WezTerm does not reliably reload when macOS switches
  appearance on a schedule — which left the terminal background on the old
  scheme while the status bar, which redraws every second, tracked the switch.
  Touching the config file from outside did not trigger a reload either, so the
  `update-right-status` handler re-applies both via `set_config_overrides()`
  once the appearance no longer matches. Takes effect within a second.

### Neovim
- **Auto-detection**: On startup and when window gains focus
- **Themes**: `github_dark_dimmed` (dark) / `github_light` (light)
- **Status bar**: Lualine automatically updates when colorscheme changes
- **Configuration**:
  - `config/nvim/lua/scrogson/plugins/colorscheme.lua`
  - `config/nvim/lua/scrogson/plugins/lualine.lua`

### Git
- **Themes**: `config/git/config-dark` / `config/git/config-light`
- **Mechanism**: `config/git/config-theme` is a symlink repointed at the active
  one. It is generated and gitignored — machine state, not config — so it no
  longer shows up dirty after every switch. `config/git/config` includes it by
  path, and git ignores the include until the symlink exists. `just link`
  creates it on a new machine.
- **Update**: Applies to the next git command

### k9s
- **Themes**: `github-dark-dimmed` / `github-light` skins
- **Skins**: `config/k9s/skins/`, symlinked into the k9s config dir
- **Config location**: `$K9S_CONFIG_DIR`, else the platform config dir — on
  macOS `~/Library/Application Support/k9s`, *not* `~/.config/k9s`.
  `k9s-theme.sh` writes the `skin:` key into whichever config k9s actually
  loads. The config itself is not tracked: k9s rewrites it on exit, and the
  copy the repo used to carry was symlinked to a path k9s never reads.
- **Update**: Requires restarting k9s to apply

### Fish
- **Themes**: `config/fish/github_dark_dimmed.fish` / `github_light.fish`
- **Mechanism**: the palettes set *universal* variables (`set -U`), which fish
  syncs across every running shell. `scripts/fish-theme.sh` just sources the
  right one from a throwaway fish process and the change lands everywhere.
  `config.fish` only picks a palette when `$__theme_mode` is unset, i.e. on a
  shell that has never had one applied — otherwise it would fight the watcher.
- **Update**: Running shells recolor without a restart; the current line
  repaints on the next keystroke or prompt.

## Troubleshooting

### Check Current System Appearance
```bash
~/.dotfiles/scripts/theme-mode.sh
```

### Check Theme Watcher Status
```bash
launchctl list | grep theme-watcher
```

### View Theme Watcher Logs
```bash
tail -f /tmp/theme-watcher.log
tail -f /tmp/theme-watcher.err
```

Note that launchd runs the watcher with a bare `PATH` that omits Homebrew, so a
script reaching for a tool installed there fails with `command not found` in
`theme-watcher.err` while working fine by hand. The launch agent sets a `PATH`
covering `/opt/homebrew/bin`; anything beyond that needs an absolute path.

### Restart Theme Watcher
```bash
just theme-watcher
```

### Disable Automatic Theme Switching
```bash
launchctl bootout gui/$(id -u)/com.user.theme-watcher
rm ~/Library/LaunchAgents/com.user.theme-watcher.plist
```

## Customization

### Change Themes

- **WezTerm**: Edit the scheme names in `config/wezterm/theme.lua`
- **Neovim**: Modify `config/nvim/lua/scrogson/plugins/colorscheme.lua`
- **Git**: Edit `config/git/config-dark` / `config-light`
- **k9s**: Edit skin names in `scripts/k9s-theme.sh`

### Change Detection Frequency

Edit `scripts/theme-watcher.sh` and change the `sleep 5` value (in seconds).

## Testing

1. Change your macOS appearance:
   - System Settings > Appearance > Light/Dark/Auto
2. WezTerm updates within a second, independently of the watcher
3. For Neovim: Switch to an nvim window - it should update immediately
4. For Git: Run any `git diff` - colors follow the new mode
5. For k9s: Restart the session
6. For Fish: Already-open shells recolor on their own

Enjoy seamless theme switching! 🎨
