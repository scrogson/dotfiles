# Zellij Color Schemes

This file documents the color schemes for both the zjstatus plugin (top bar) and the Zellij theme (bottom hints bar and UI elements).

## Top Status Bar (zjstatus plugin)

## Dark Mode (github-dark-dimmed)
- **Background**: `#22272e` (dark gray)
- **Primary accent**: `#89b4fa` (light blue)
- **Active tab text**: `#ffffff` (white)
- **Inactive tab text**: `#6C7086` (muted gray)
- **Mode indicator background**: `#89B4FA` (blue)
- **Mode indicator text**: `#000000` (black)
- **Tmux mode**: `#ffc387` (orange)
- **Locked icon**: `#ffffff` (white)

## Light Mode (github-light)
- **Background**: `#f6f8fa` (light gray)
- **Primary accent**: `#0969da` (GitHub blue)
- **Active tab text**: `#24292f` (near black)
- **Inactive tab text**: `#6e7781` (gray)
- **Mode indicator background**: `#0969da` (blue)
- **Mode indicator text**: `#ffffff` (white)
- **Tmux mode**: `#bc4c00` (orange)
- **Locked icon**: `#24292f` (dark)

### Files
- **Dark config**: `zjstatus-dark.kdl`
- **Light config**: `zjstatus-light.kdl`

---

## Bottom Hints Bar & UI (Zellij Theme)

### Dark Mode (github-dark-dimmed)
- **Background**: `34 39 46` (RGB - dark gray, matches terminal)
- **Text unselected**: `173 186 199` (muted gray)
- **Text selected**: `205 217 229` (brighter gray)
- **Emphasis colors**: Red, Green, Blue, Yellow for various UI elements

### Light Mode (github-light)
- **Background**: `255 255 255` (RGB - white, matches terminal)
- **Text unselected**: `110 119 129` (gray)
- **Text selected**: `36 41 47` (near black)
- **Emphasis colors**: Red, Green, Blue, Orange for various UI elements

### Files
- **Dark theme**: `themes/github-dark-dimmed.kdl`
- **Light theme**: `themes/github-light.kdl`

---

## Switcher Script
- **Script**: `../../scripts/zellij-theme.sh`
- Updates both zjstatus configuration and theme files
- Creates symlinks in `~/.config/zellij/themes/`

## Customization
- **Top bar**: Edit `zjstatus-{dark,light}.kdl` files
  - Color format: `#[fg=<foreground>,bg=<background>]`
- **Bottom bar & UI**: Edit `themes/github-{dark-dimmed,light}.kdl` files
  - Color format: RGB triplets (e.g., `255 255 255`)

## GitHub Color References
- https://primer.style/foundations/color/overview
