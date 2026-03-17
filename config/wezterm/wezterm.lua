local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux
local projects = require 'projects'
local config = wezterm.config_builder()

local direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

local function split_nav(key)
  return {
    key = key,
    mods = 'ALT',
    action = act.ActivatePaneDirection(direction_keys[key]),
  }
end

local function is_dark()
  return wezterm.gui.get_appearance():find 'Dark'
end

-- Returns white or black depending on background luminance
local function contrast_fg(color)
  local c
  if type(color) == 'string' then
    c = wezterm.color.parse(color)
  else
    c = color
  end
  local r, g, b = c:srgba_u8()
  local luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
  return luminance > 0.5 and '#000000' or '#ffffff'
end

local function scheme_for_appearance()
  if is_dark() then
    return 'GitHub Dark Dimmed'
  else
    return 'Github (base16)'
  end
end

local themes = {
  dark = {
    bg = '#22272e',
    active_tab_bg = '#2d333b',
    active_tab_fg = '#c0c0c0',
    inactive_tab_fg = '#636e7b',
    hover_bg = '#373e47',
    hover_fg = '#909090',
    status_bg = '#539bf5',
    status_fg = '#000000',
    leader_fg = '#ffc387',
    muted = '#768390',
  },
  light = {
    bg = '#f6f8fa',
    active_tab_bg = '#ffffff',
    active_tab_fg = '#24292f',
    inactive_tab_fg = '#57606a',
    hover_bg = '#eaeef2',
    hover_fg = '#24292f',
    status_bg = '#0969da',
    status_fg = '#ffffff',
    leader_fg = '#bf8700',
    muted = '#57606a',
  },
}

local function theme()
  return is_dark() and themes.dark or themes.light
end

-- Appearance
config.enable_kitty_keyboard = true
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.initial_cols = 175
config.initial_rows = 37
config.font_size = 14.0
config.font = wezterm.font 'Iosevka Nerd Font'
config.color_scheme = scheme_for_appearance()
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = false
config.window_decorations = 'RESIZE'
config.tab_max_width = 32
config.pane_focus_follows_mouse = true
config.status_update_interval = 1000

-- Maximize on startup
wezterm.on('gui-attached', function(domain)
  local workspace = mux.get_active_workspace()
  for _, window in ipairs(mux.all_windows()) do
    if window:get_workspace() == workspace then
      window:gui_window():maximize()
    end
  end
end)

-- Git branch cache
local git_cache = { path = '', branch = '', time = 0 }

-- Status bar
wezterm.on('update-right-status', function(window, pane)
  local workspace = window:active_workspace()

  -- Leader indicator
  local leader = window:leader_is_active() and '  LEADER ' or ''

  local t = theme()
  local purple = '#8b5fc7'
  window:set_left_status(wezterm.format {
    { Foreground = { Color = contrast_fg(purple) } },
    { Background = { Color = purple } },
    { Text = '  ' .. workspace .. '  ' },
    { Background = { Color = t.bg } },
    { Foreground = { Color = t.leader_fg } },
    { Text = leader },
  })

  local ok, cwd_uri = pcall(function()
    return pane:get_current_working_dir()
  end)
  local cwd = ''
  local cwd_path = ''
  if ok and cwd_uri then
    cwd_path = cwd_uri.file_path or ''
    cwd = cwd_path:match '([^/]+)/?$' or cwd_path
  end

  -- Git branch (cached, refresh every 5s or on path change)
  local now = os.time()
  if cwd_path ~= '' and (cwd_path ~= git_cache.path or (now - git_cache.time) >= 5) then
    local success, stdout = wezterm.run_child_process {
      'git', '-C', cwd_path, 'rev-parse', '--abbrev-ref', 'HEAD',
    }
    git_cache.branch = success and (wezterm.nerdfonts.dev_git_branch .. ' ' .. stdout:gsub('%s+$', '')) or ''
    git_cache.path = cwd_path
    git_cache.time = now
  end

  local date = wezterm.strftime '%a %b %-d %H:%M'

  -- Right status with powerline arrows and gradient
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  local segments = {}
  if git_cache.branch ~= '' then
    table.insert(segments, git_cache.branch)
  end
  table.insert(segments, cwd)
  table.insert(segments, date)

  local color_scheme = window:effective_config().resolved_palette
  local fg = color_scheme.foreground
  local bg = wezterm.color.parse(color_scheme.background)
  local purple_color = wezterm.color.parse(purple)

  local gradient_to
  if is_dark() then
    gradient_to = purple_color:darken(0.6)
  else
    gradient_to = purple_color:lighten(0.4)
  end

  local gradient = wezterm.color.gradient({ orientation = 'Horizontal', colors = { purple_color, gradient_to } }, #segments)

  local elements = {}
  for i, seg in ipairs(segments) do
    if i == 1 then
      table.insert(elements, { Background = { Color = 'none' } })
    end
    table.insert(elements, { Foreground = { Color = gradient[i] } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })
    table.insert(elements, { Foreground = { Color = contrast_fg(gradient[i]) } })
    table.insert(elements, { Background = { Color = gradient[i] } })
    table.insert(elements, { Text = ' ' .. seg .. ' ' })
  end

  window:set_right_status(wezterm.format(elements))
end)

-- Tab title: show index + process name
wezterm.on('format-tab-title', function(tab)
  local index = tab.tab_index + 1
  local title = tab.tab_title
  if not title or #title == 0 then
    title = tab.active_pane.foreground_process_name:match '([^/]+)$' or tab.active_pane.title
  end
  if #title > 24 then
    title = title:sub(1, 24) .. '…'
  end

  local t = theme()
  local is_active = tab.is_active
  return {
    { Background = { Color = is_active and t.active_tab_bg or t.bg } },
    { Foreground = { Color = is_active and t.active_tab_fg or t.inactive_tab_fg } },
    { Text = '  ' .. index .. ' ' .. title .. '  ' },
  }
end)

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }
config.keys = {
  -- Alt+h/j/k/l: navigate panes
  split_nav 'h',
  split_nav 'j',
  split_nav 'k',
  split_nav 'l',

  -- Alt+=/-: resize panes
  { key = '=', mods = 'ALT', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = '-', mods = 'ALT', action = act.AdjustPaneSize { 'Left', 5 } },

  -- Alt+f: toggle pane zoom
  { key = 'f', mods = 'ALT', action = act.TogglePaneZoomState },

  -- Leader + v: split right
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- Leader + s: split down
  { key = 's', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- Leader + x: close pane
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

  -- Leader + z: toggle pane zoom
  { key = 'z', mods = 'LEADER', action = act.TogglePaneZoomState },

  -- Leader + c: new tab
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },

  -- Leader + ,: rename tab
  {
    key = ',',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Enter new tab title',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    },
  },

  -- Leader + p/n: previous/next tab
  { key = 'p', mods = 'LEADER', action = act.ActivateTabRelative(-1) },
  { key = 'n', mods = 'LEADER', action = act.ActivateTabRelative(1) },

  -- Leader + [: enter copy mode (scrollback)
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },

  -- Leader + h/j/k/l: move focus
  { key = 'h', mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },

  -- Leader + o: focus next pane
  { key = 'o', mods = 'LEADER', action = act.PaneSelect },

  -- Leader + 1-9: go to tab by number
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = act.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = act.ActivateTab(4) },
  { key = '6', mods = 'LEADER', action = act.ActivateTab(5) },
  { key = '7', mods = 'LEADER', action = act.ActivateTab(6) },
  { key = '8', mods = 'LEADER', action = act.ActivateTab(7) },
  { key = '9', mods = 'LEADER', action = act.ActivateTab(8) },

  -- Leader + Ctrl+a: send Ctrl+a to terminal
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },

  -- Leader + f: fuzzy project picker
  { key = 'f', mods = 'LEADER', action = projects.show_picker() },

  -- Leader + F: create workspace from path
  { key = 'F', mods = 'LEADER', action = projects.create_from_path() },

  -- Leader + w: workspace launcher (session picker)
  { key = 'w', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'WORKSPACES' } },

  -- Leader + $: rename workspace
  {
    key = '$',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Rename workspace:',
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          mux.rename_workspace(mux.get_active_workspace(), line)
        end
      end),
    },
  },

  -- Ctrl+Shift+n: next workspace
  { key = 'n', mods = 'CTRL|SHIFT', action = act.SwitchWorkspaceRelative(1) },

  -- Ctrl+Shift+p: command palette
  { key = 'p', mods = 'CTRL|SHIFT', action = act.ActivateCommandPalette },
}

-- Handle fzf project picker selection via user-var
wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'project_dir' then
    -- WezTerm auto-decodes the base64 value
    local dir = value
    if not dir or #dir == 0 then return end

    local caller_pane_id = projects.caller_pane_id
    projects.caller_pane_id = nil
    if not caller_pane_id then return end

    -- Unzoom, then close the fzf pane
    window:perform_action(act.TogglePaneZoomState, pane)
    window:perform_action(act.CloseCurrentPane { confirm = false }, pane)

    wezterm.time.call_after(0.3, function()
      local caller_pane = mux.get_pane(caller_pane_id)
      if not caller_pane then return end
      local tab = caller_pane:tab()
      if not tab then return end
      local w = tab:window()
      if not w then return end
      projects.switch_to_dir(w:gui_window(), caller_pane, dir)
    end)
  end
end)

local t = theme()
config.colors = {
  tab_bar = {
    background = t.bg,
    active_tab = {
      bg_color = t.active_tab_bg,
      fg_color = t.active_tab_fg,
    },
    inactive_tab = {
      bg_color = t.bg,
      fg_color = t.inactive_tab_fg,
    },
    inactive_tab_hover = {
      bg_color = t.hover_bg,
      fg_color = t.hover_fg,
      italic = true,
    },
    new_tab = {
      bg_color = t.bg,
      fg_color = t.inactive_tab_fg,
    },
    new_tab_hover = {
      bg_color = t.hover_bg,
      fg_color = t.hover_fg,
      italic = true,
    },
  },
}

return config
