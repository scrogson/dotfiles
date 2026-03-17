local wezterm = require 'wezterm'
local module = {}

module.direction_keys = {
  h = 'Left',
  j = 'Down',
  k = 'Up',
  l = 'Right',
}

function module.split_nav(key)
  return {
    key = key,
    mods = 'ALT',
    action = wezterm.action.ActivatePaneDirection(module.direction_keys[key]),
  }
end

function module.is_dark()
  return wezterm.gui.get_appearance():find 'Dark'
end

-- Returns white or black depending on background luminance
function module.contrast_fg(color)
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

function module.scheme_for_appearance()
  if module.is_dark() then
    return 'GitHub Dark Dimmed'
  else
    return 'Github (base16)'
  end
end

module.themes = {
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

function module.current()
  return module.is_dark() and module.themes.dark or module.themes.light
end

return module
