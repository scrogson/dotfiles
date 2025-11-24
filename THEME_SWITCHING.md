# Automatic Theme Switching Setup

This setup automatically switches themes for Neovim, Alacritty, and Zellij based on your macOS system appearance (light/dark mode).

## How It Works

1. **Theme Detection**: `scripts/theme-mode.sh` detects the current macOS appearance
2. **Neovim**: Automatically switches between `github_dark_dimmed` and `github_light` on focus/startup
   - **Lualine status bar**: Automatically updates to match the theme
3. **Alacritty**: Updates theme import in config based on system appearance
4. **Zellij**: Updates theme setting AND status bar (zjstatus) colors in config based on system appearance

## Files Created

```
.dotfiles/
├── scripts/
│   ├── theme-mode.sh          # Detects macOS appearance (dark/light)
│   ├── alacritty-theme.sh     # Updates Alacritty config
│   ├── zellij-theme.sh        # Updates Zellij config
│   ├── update-themes.sh       # Master script to update all themes
│   └── theme-watcher.sh       # Background process to watch for changes
├── config/
│   ├── alacritty/github/
│   │   ├── dimmed.toml        # Dark theme (existing)
│   │   └── light.toml         # Light theme (new)
│   ├── zellij/
│   │   ├── zjstatus-dark.kdl  # Dark status bar colors (top bar)
│   │   ├── zjstatus-light.kdl # Light status bar colors (top bar)
│   │   └── themes/
│   │       ├── github-dark-dimmed.kdl  # Dark theme (bottom bar & UI)
│   │       └── github-light.kdl        # Light theme (bottom bar & UI)
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

### 2. Enable Automatic Theme Switching (Optional)

To automatically switch themes when you change macOS appearance:

```bash
# Copy the launch agent to ~/Library/LaunchAgents/
mkdir -p ~/Library/LaunchAgents
ln -sf ~/.dotfiles/config/launchd/com.user.theme-watcher.plist ~/Library/LaunchAgents/

# Load the launch agent
launchctl load ~/Library/LaunchAgents/com.user.theme-watcher.plist
```

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

### Neovim
- **Auto-detection**: On startup and when window gains focus
- **Themes**: `github_dark_dimmed` (dark) / `github_light` (light)
- **Status bar**: Lualine automatically updates when colorscheme changes
- **Configuration**:
  - `config/nvim/lua/scrogson/plugins/colorscheme.lua`
  - `config/nvim/lua/scrogson/plugins/lualine.lua`

### Alacritty
- **Auto-reload**: Enabled via `live_config_reload = true`
- **Themes**: Imported from `config/alacritty/github/dimmed.toml` or `light.toml`
- **Update**: Run `update-themes` or let the watcher do it

### Zellij
- **Themes**: `github-dark-dimmed` (dark) / `github-light` (light)
- **Top status bar** (zjstatus): Automatically adjusted colors
  - Dark mode: Dark backgrounds (#22272e), bright accents (#89b4fa)
  - Light mode: Light backgrounds (#ffffff), blue accents (#0969da)
- **Bottom hints bar & UI**: Uses Zellij theme files
  - Dark mode: Dark backgrounds (34 39 46), muted text
  - Light mode: White backgrounds (255 255 255), dark text
- **Update**: Requires restarting Zellij sessions to apply
- **Note**: The config is updated, but existing sessions need restart
- **Configuration**:
  - Main: `config/zellij/config.kdl`
  - Top bar: `config/zellij/zjstatus-{dark,light}.kdl`
  - Theme files: `config/zellij/themes/github-{dark-dimmed,light}.kdl`

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
```

### Restart Theme Watcher
```bash
launchctl unload ~/Library/LaunchAgents/com.user.theme-watcher.plist
launchctl load ~/Library/LaunchAgents/com.user.theme-watcher.plist
```

### Disable Automatic Theme Switching
```bash
launchctl unload ~/Library/LaunchAgents/com.user.theme-watcher.plist
rm ~/Library/LaunchAgents/com.user.theme-watcher.plist
```

## Customization

### Change Themes

Edit the scripts to use different themes:

- **Neovim**: Modify `config/nvim/lua/scrogson/plugins/colorscheme.lua`
- **Alacritty**: Create new theme files in `config/alacritty/github/`
- **Zellij**: Edit theme names in `scripts/zellij-theme.sh`

### Change Detection Frequency

Edit `scripts/theme-watcher.sh` and change the `sleep 5` value (in seconds).

## Testing

1. Change your macOS appearance:
   - System Settings > Appearance > Light/Dark/Auto
2. For Neovim: Switch to an nvim window - it should update immediately
3. For Alacritty: Run `update-themes` or wait for the watcher
4. For Zellij: Run `update-themes` and restart your session

Enjoy seamless theme switching! 🎨
