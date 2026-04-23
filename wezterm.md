# WezTerm Guide: Replacing Zellij

A practical guide to WezTerm multiplexing, workspace automation, and status bar configuration.

---

## Concepts: Mental Model

WezTerm's terminology maps roughly to tmux/Zellij like this:

| Zellij / tmux | WezTerm |
|---|---|
| Session | **Workspace** |
| Window | **Tab** |
| Pane | **Pane** |
| Session server | **Mux Domain** |

**Domains** are the transport/server layer. **Workspaces** are the named session groups you actually work in. These are separate concerns.

---

## Domains

There are three types of multiplexing domains in WezTerm.

Multiplexing in WezTerm is based around the concept of multiplexing domains — a domain is a distinct set of windows and tabs. When WezTerm starts it creates a default local domain, but it can be configured to start or connect to additional domains.

### 1. Local Domain (default)

The default — just tabs and panes managed inside the GUI process. No persistence if you close WezTerm.

### 2. Unix Domain

Runs a persistent mux server on a unix socket. This is what gives you true detach/re-attach like tmux. **This is what you want for replacing Zellij locally.**

```lua
-- wezterm.lua
config.unix_domains = { { name = 'main' } }

-- Auto-connect on startup (omit if you prefer manual attach)
config.default_gui_startup_args = { 'connect', 'main' }
```

To connect manually instead:

```bash
wezterm connect main
```

### 3. SSH / SSHMUX Domain

Remote multiplexing over SSH. Requires WezTerm installed on the remote host.

```bash
# Connect to a host defined in ~/.ssh/config
wezterm connect SSHMUX:my.server

# Spawn a new tab in an existing GUI instance
wezterm cli spawn --domain-name SSHMUX:my.server
```

SSH domains auto-populate from your `~/.ssh/config`. Each host gets both a plain `SSH:` prefixed domain and a multiplexing `SSHMUX:` prefixed domain.

---

## Workspaces

Workspaces are WezTerm's equivalent of tmux/Zellij sessions.

WezTerm doesn't have an exact match to tmux sessions, but has a similar concept known as Workspaces. Every MuxWindow is associated with a workspace, which is just a label. The WezTerm GUI is focused on the active workspace — it presents a GUI window for each MuxWindow in that workspace. When switching the active workspace, WezTerm swaps the GUI window contents with the MuxWindows belonging to the now-focused workspace.

### Useful Key Assignments

```lua
config.keys = {
  -- Switch workspaces relative to current
  { key = 'n', mods = 'CTRL|SHIFT',
    action = wezterm.action.SwitchWorkspaceRelative(1) },
  { key = 'p', mods = 'CTRL|SHIFT',
    action = wezterm.action.SwitchWorkspaceRelative(-1) },

  -- Show workspace launcher (like a session picker)
  { key = 'w', mods = 'LEADER',
    action = wezterm.action.ShowLauncherArgs { flags = 'WORKSPACES' } },

  -- Rename current workspace
  { key = '$', mods = 'LEADER',
    action = wezterm.action.PromptInputLine {
      description = 'Rename workspace:',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    }},
}
```

---

## Automating Layouts: `gui-startup`

The `gui-startup` event fires when WezTerm launches and is the primary hook for pre-building workspace layouts. This is the WezTerm equivalent of a tmux/Zellij session config.

```lua
local wezterm = require 'wezterm'
local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  -- Allows `wezterm start -- something` to affect the initial window
  local args = {}
  if cmd then args = cmd.args end

  -- Workspace: "faraday" project
  local faraday_dir = wezterm.home_dir .. '/code/faraday'
  local tab, build_pane, window = mux.spawn_window {
    workspace = 'faraday',
    cwd = faraday_dir,
    args = args,
  }
  -- Split: editor top (60%), build output bottom
  local editor_pane = build_pane:split {
    direction = 'Top',
    size = 0.6,
    cwd = faraday_dir,
  }
  build_pane:send_text 'cargo watch -x check\n'

  -- Workspace: "hub" project
  local hub_dir = wezterm.home_dir .. '/code/hub'
  local tab2, pane2, window2 = mux.spawn_window {
    workspace = 'hub',
    cwd = hub_dir,
  }
  pane2:split { direction = 'Top', size = 0.6 }

  -- Start focused on faraday
  mux.set_active_workspace 'faraday'
end)
```

### Pane Split Options

```lua
pane:split {
  direction = 'Top',    -- 'Top' | 'Bottom' | 'Left' | 'Right'
  size = 0.6,           -- fraction of the current pane
  cwd = '/some/path',
  args = { 'nvim', '.' },
}
```

### Maximizing on Startup

Use `gui-attached` (fires after `gui-startup`) to maximize windows:

```lua
wezterm.on('gui-attached', function(domain)
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():maximize()
    end
  end
end)
```

---

## On-Demand Project Switcher

Rather than only setting up at startup, you can trigger a project selector manually via a keybinding — this is the pattern that most directly replaces Zellij's session manager.

### `projects.lua`

```lua
-- ~/.config/wezterm/projects.lua
local wezterm = require 'wezterm'
local module = {}

local function project_dirs()
  return {
    wezterm.home_dir .. '/code/faraday',
    wezterm.home_dir .. '/code/hub',
    wezterm.home_dir .. '/code/attesta',
  }
end

local function activate_or_create(window, pane, project_dir)
  local project_name = project_dir:match('([^/]+)$')  -- basename
  local all_workspaces = wezterm.mux.get_workspace_names()

  -- If workspace already exists, just switch to it
  for _, ws in ipairs(all_workspaces) do
    if ws == project_name then
      window:perform_action(
        wezterm.action.SwitchToWorkspace { name = project_name },
        pane
      )
      return
    end
  end

  -- Otherwise create it with a layout
  window:perform_action(
    wezterm.action.SwitchToWorkspace {
      name = project_name,
      spawn = { cwd = project_dir },
    },
    pane
  )
end

function module.show_picker()
  local choices = {}
  for _, dir in ipairs(project_dirs()) do
    table.insert(choices, { label = dir })
  end
  return wezterm.action.InputSelector {
    action = wezterm.action_callback(function(window, pane, id, label)
      if label then activate_or_create(window, pane, label) end
    end),
    title = 'Select Project',
    choices = choices,
    fuzzy = true,
  }
end

return module
```

### Wiring it up in `wezterm.lua`

```lua
local projects = require 'projects'

config.keys = {
  -- LEADER + p = fuzzy project picker (like Zellij's session manager)
  { key = 'p', mods = 'LEADER', action = projects.show_picker() },

  -- LEADER + w = built-in workspace switcher
  { key = 'w', mods = 'LEADER',
    action = wezterm.action.ShowLauncherArgs { flags = 'WORKSPACES' } },
}
```

---

## Summary: Replacing Zellij Locally

The complete setup for a Zellij-equivalent local experience:

1. **Unix domain** in config → gives you a persistent server you can detach/re-attach from
2. **`gui-startup`** → pre-bake your most common workspace layouts
3. **`InputSelector` or `ShowLauncherArgs { flags = 'WORKSPACES' }`** → session manager equivalent
4. **`SwitchToWorkspace`** in keybinds → fast switching

The biggest difference from Zellij: WezTerm's workspaces are GUI-window-swapping rather than in-terminal navigation, which actually feels more natural since each project gets real native windows.

---

## Status Bar

WezTerm's tab bar doubles as a fully customizable status bar. You get three regions:

| Region | Method | Alignment |
|---|---|---|
| Left of tabs | `window:set_left_status(...)` | Left-aligned, takes space it needs |
| Right of tabs | `window:set_right_status(...)` | Right-aligned, clipped if too wide |
| Per-tab content | `format-tab-title` event | Per-tab |

These are driven by events fired on a configurable timer:

- `update-right-status` — used for both left and right status updates
- `format-tab-title` — fires when tab title needs recomputing

WezTerm ensures only a single instance of the event is outstanding — if the hook takes longer than `status_update_interval` to complete, it won't schedule another call until that interval has elapsed.

### Key Config Options

```lua
-- Switch to retro tab bar — required for powerline glyphs and custom backgrounds.
-- The default "fancy" bar is less customizable.
config.use_fancy_tab_bar = false

-- Move tab bar to bottom (like Zellij)
config.tab_bar_at_bottom = true

-- Status refresh rate
config.status_update_interval = 1000  -- ms

-- Always show tab bar even with a single tab
config.hide_tab_bar_if_only_one_tab = false

config.show_tab_index_in_tab_bar = false
```

> `use_fancy_tab_bar = false` is the key setting. The retro tab bar renders correctly with Nerd Font powerline glyphs and custom background colors per segment.

---

### Basic Example

```lua
wezterm.on('update-right-status', function(window, pane)
  local workspace = window:active_workspace()
  local date = wezterm.strftime '%H:%M'
  local cwd_uri = pane:get_current_working_dir()
  local cwd = cwd_uri and cwd_uri.file_path or ''

  window:set_left_status(wezterm.format {
    { Foreground = { Color = '#a6e3a1' } },
    { Text = '  ' .. workspace .. '  ' },
  })

  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#89b4fa' } },
    { Text = cwd .. '  ' },
    { Foreground = { Color = '#cdd6f4' } },
    { Text = date .. '  ' },
  })
end)
```

---

### Powerline-style Status Bar

```lua
local SOLID_LEFT_ARROW = utf8.char(0xe0b2)   -- 
local SOLID_RIGHT_ARROW = utf8.char(0xe0b0)  -- 

wezterm.on('update-right-status', function(window, pane)
  local cells = {}

  -- Workspace name
  table.insert(cells, '  ' .. window:active_workspace() .. ' ')

  -- CWD (basename only)
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local path = cwd_uri.file_path
    local basename = path:match('([^/]+)/?$') or path
    table.insert(cells, '  ' .. basename .. ' ')
  end

  -- Battery
  for _, b in ipairs(wezterm.battery_info()) do
    local icon = b.state == 'Charging' and '⚡' or '🔋'
    table.insert(cells, string.format('%s %.0f%% ', icon, b.state_of_charge * 100))
  end

  -- Time
  table.insert(cells, ' ' .. wezterm.strftime '%H:%M ')

  -- Segment colors (Catppuccin Mocha palette)
  local colors = { '#313244', '#45475a', '#585b70', '#7f849c' }

  local elements = {}

  for i, text in ipairs(cells) do
    local bg = colors[i] or colors[#colors]
    local prev_bg = colors[i - 1] or 'none'

    -- Leading arrow separator
    table.insert(elements, { Foreground = { Color = bg } })
    table.insert(elements, { Background = { Color = i == 1 and 'none' or prev_bg } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })

    -- Segment text
    table.insert(elements, { Foreground = { Color = '#cdd6f4' } })
    table.insert(elements, { Background = { Color = bg } })
    table.insert(elements, { Text = text })
  end

  window:set_right_status(wezterm.format(elements))
end)
```

---

### Customizing Tab Titles

```lua
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  local title = tab.tab_title

  -- Fall back to process name if no explicit title is set
  if not title or #title == 0 then
    title = pane.foreground_process_name:match('([^/]+)$') or pane.title
  end

  local is_active = tab.is_active
  return {
    { Background = { Color = is_active and '#313244' or '#1e1e2e' } },
    { Foreground = { Color = is_active and '#cdd6f4' or '#585b70' } },
    { Text = ' ' .. (tab.tab_index + 1) .. ': ' .. title .. ' ' },
  }
end)
```

---

### What You Can Show

Since it's all Lua with access to the `window` and `pane` objects, you can pull in essentially anything:

| Data | API |
|---|---|
| Current workspace name | `window:active_workspace()` |
| Current working directory | `pane:get_current_working_dir()` |
| Running process | `pane:get_foreground_process_name()` |
| Battery state & percentage | `wezterm.battery_info()` |
| Date / time | `wezterm.strftime(...)` |
| Active modal keytable | `window:active_key_table()` |
| Leader key active? | `window:leader_is_active()` |
| Arbitrary shell output | `io.popen(...)` |

### Git Branch Example

```lua
local function get_git_branch(cwd)
  local handle = io.popen('git -C ' .. cwd .. ' rev-parse --abbrev-ref HEAD 2>/dev/null')
  if handle then
    local result = handle:read('*l')
    handle:close()
    return result
  end
end

wezterm.on('update-right-status', function(window, pane)
  local cwd_uri = pane:get_current_working_dir()
  local branch = ''
  if cwd_uri then
    branch = get_git_branch(cwd_uri.file_path) or ''
    if branch ~= '' then branch = '  ' .. branch end
  end

  window:set_right_status(wezterm.format {
    { Foreground = { Color = '#f38ba8' } },
    { Text = branch .. '  ' },
    { Foreground = { Color = '#cdd6f4' } },
    { Text = wezterm.strftime '%H:%M  ' },
  })
end)
```

> **Note:** `io.popen` runs synchronously, so avoid slow commands (network calls, etc.) inside the status update handler — it blocks the UI update cycle.
