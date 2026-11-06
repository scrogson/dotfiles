-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Screenshot without a Print key (75% keyboard). Was: Google Maps webapp.
hl.unbind("SUPER + SHIFT + S")
o.bind("SUPER + SHIFT + S", "Screenshot", "omarchy-capture-screenshot")

-- Drop-down terminal (plain shell). Replaces Omarchy's Quake console, which
-- seeds the default agent (Claude).
hl.unbind("SUPER + grave")
o.bind("SUPER + GRAVE", "Toggle drop-down terminal", "claude-dropdown")

-- Typed pop-up calculator (qalc). XF86Calculator was: omacalc button calculator.
-- The Keychron's F1 sends XF86MonBrightnessDown without Fn, so SUPER+F1 is
-- bound to that keysym.
hl.unbind("XF86Calculator")
o.bind("XF86Calculator", "Toggle calculator", "calc-popup")
o.bind("SUPER + XF86MonBrightnessDown", "Toggle calculator", "calc-popup")

-- macOS-style shortcuts: SUPER acts as Cmd. In GUI apps SUPER+key sends the
-- app's CTRL shortcut; terminals get the original chord, since WezTerm already
-- treats SUPER as Cmd. Omarchy's window bindings that collided move below.

-- Window management moved out of the way (was SUPER + key).
hl.unbind("SUPER + W")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())
hl.unbind("SUPER + F")
hl.unbind("SUPER + CTRL + F")
o.bind("SUPER + CTRL + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
o.bind("SUPER + SHIFT + CTRL + F", "Tiled full screen", "omarchy-hyprland-window-tiled-fullscreen-toggle")
hl.unbind("SUPER + S")
hl.unbind("SUPER + ALT + S")
o.bind("SUPER + ALT + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
o.bind("SUPER + SHIFT + ALT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
hl.unbind("SUPER + G")
o.bind("SUPER + CTRL + G", "Toggle window grouping", hl.dsp.group.toggle())
hl.unbind("SUPER + J")
o.bind("SUPER + ALT + J", "Toggle window split", hl.dsp.layout("togglesplit"))
hl.unbind("SUPER + P")
o.bind("SUPER + ALT + P", "Pseudo window", hl.dsp.window.pseudo())
hl.unbind("SUPER + O")
o.bind("SUPER + ALT + O", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")
hl.unbind("SUPER + L")
-- SUPER + ALT + L was Omarchy's "cycle layout back"; that moves to SUPER + SHIFT + ALT + L.
o.rebind("SUPER + ALT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + SHIFT + ALT + L", "Cycle workspace layout back", "omarchy-hyprland-workspace-layout-toggle back")
hl.unbind("SUPER + K")
o.bind("SUPER + SHIFT + K", "Keybindings", "omarchy-menu-keybindings")
hl.unbind("SUPER + T")
o.bind("SUPER + ALT + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))

-- The down/up split mirrors Omarchy's clipboard bindings to avoid stuck
-- synthetic keys.
local function send_shortcut_once(mods, key)
  hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))

  hl.timer(function()
    hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
  end, { timeout = 50, type = "oneshot" })
end

-- Omarchy's terminal tag rule matches "wezterm" as the whole class, which can
-- miss WezTerm's org.wezfurlong.wezterm app-id, so check the class as well.
local function is_terminal(window)
  for _, tag in ipairs(window.tags or {}) do
    if tag:gsub("%*$", "") == "terminal" then
      return true
    end
  end

  return (window.class or ""):find("wezterm") ~= nil
end

local function cmd(mods, key, description, send_mods, send_key)
  local chord = mods:gsub(" ", " + ") .. " + " .. key
  send_mods = send_mods or (mods:gsub("SUPER", "CTRL"))
  send_key = send_key or key

  o.bind(chord, "Cmd: " .. description, function()
    local window = hl.get_active_window()

    if window and not is_terminal(window) then
      send_shortcut_once(send_mods, send_key)
    else
      send_shortcut_once(mods, key)
    end
  end)
end

cmd("SUPER", "A", "Select all")
cmd("SUPER", "B", "Bold")
cmd("SUPER", "I", "Italic")
cmd("SUPER", "U", "Underline")
cmd("SUPER", "F", "Find")
cmd("SUPER", "G", "Find next")
cmd("SUPER", "K", "Quick switcher / insert link")
cmd("SUPER", "L", "Location bar")
cmd("SUPER", "N", "New window")
cmd("SUPER", "O", "Open")
cmd("SUPER", "P", "Print")
cmd("SUPER", "R", "Reload")
cmd("SUPER", "S", "Save")
cmd("SUPER", "T", "New tab")
cmd("SUPER SHIFT", "T", "Reopen closed tab")
cmd("SUPER", "W", "Close tab")
cmd("SUPER", "Z", "Undo")
cmd("SUPER SHIFT", "Z", "Redo")
cmd("SUPER", "bracketleft", "Back", "ALT", "Left")
cmd("SUPER", "bracketright", "Forward", "ALT", "Right")
cmd("SUPER SHIFT", "bracketleft", "Previous tab", "CTRL", "Prior")
cmd("SUPER SHIFT", "bracketright", "Next tab", "CTRL", "Next")

-- Dictation keys from before Alt + Space and Right Alt became the defaults.
-- Remove these lines to give the keys back to applications.
if o.dictation_installed and o.dictation_installed() then
  o.bind("SUPER + CTRL + X", "Toggle dictation", "omarchy-dictation toggle")
  o.bind_hold("F9", "Start dictation (push-to-talk)", "omarchy-dictation start", "Stop dictation (push-to-talk)", "omarchy-dictation stop")
end

-- Equalize the widths of the tiled columns on the current workspace. Dwindle
-- has no built-in balance, so this nudges the widest-off column toward the
-- average until all are within a couple of pixels. A resize can move either
-- edge depending on the split tree, so a wrong-way nudge is undone and flipped.
local function tiled_columns()
  local cols, seen = {}, {}
  for _, w in ipairs(hl.get_workspace_windows(hl.get_active_workspace())) do
    if not w.floating and not w.hidden and w.mapped and (w.fullscreen or 0) == 0 and not seen[w.at.x] then
      seen[w.at.x] = true
      table.insert(cols, w)
    end
  end
  table.sort(cols, function(a, b) return a.at.x < b.at.x end)
  return cols
end

local function column_width(address)
  for _, w in ipairs(tiled_columns()) do
    if w.address == address then return w.size.x end
  end
end

local function equalize_columns()
  local cols = tiled_columns()
  local n = #cols
  if n < 2 then return end

  -- Scrolling sizes columns as a fraction of the screen and can set them all
  -- at once, so give every column an equal share that fits on screen.
  if hl.get_active_workspace().tiled_layout == "scrolling" then
    hl.dispatch(hl.dsp.layout(string.format("colresize all %.4f", 1 / n)))
    return
  end

  local gap = cols[2].at.x - (cols[1].at.x + cols[1].size.x)
  local span = cols[n].at.x + cols[n].size.x - cols[1].at.x
  local target = math.floor((span - (n - 1) * gap) / n + 0.5)

  for _ = 1, 30 do
    local worst, err = nil, 2
    for _, w in ipairs(tiled_columns()) do
      local e = math.abs(w.size.x - target)
      if e > err then worst, err = w, e end
    end
    if not worst then return end

    local d = target - worst.size.x
    hl.dispatch(hl.dsp.window.resize({ x = d, y = 0, relative = true, window = worst }))
    local now = column_width(worst.address)
    if now and math.abs(now - target) >= err then
      hl.dispatch(hl.dsp.window.resize({ x = -2 * d, y = 0, relative = true, window = worst }))
      now = column_width(worst.address)
      if now and math.abs(now - target) >= err then
        hl.dispatch(hl.dsp.window.resize({ x = d, y = 0, relative = true, window = worst }))
        return
      end
    end
  end
end

o.bind("SUPER + ALT + E", "Equalize window widths", equalize_columns)
