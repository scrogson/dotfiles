-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

local omarchy_gdk_scale = 2
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })

-- LG UltraFine 5K (Thunderbolt). It shows up as two outputs: one offers only
-- 2560x2880 (the second half of the 5K panel), the other also takes a single
-- 4K signal. The XPS 13's graphics can't drive 4K here alongside its own 4K
-- panel, so: lid closed (Omarchy clamshell) -> 4K at 1.5, lid open -> 1440p.
-- Omarchy reloads Hyprland when clamshell mode changes, re-running this.
local ultrafine = "LG Electronics LG UltraFine 008NTKFLR253"
local clamshell_flag = io.open(os.getenv("HOME") .. "/.local/state/omarchy/toggles/hypr/internal-monitor-clamshell.lua", "r")
local clamshell = clamshell_flag ~= nil
if clamshell_flag then clamshell_flag:close() end

hl.monitor({
  output = "desc:" .. ultrafine,
  mode = clamshell and "3840x2160@60" or "2560x1440@60",
  position = "auto",
  scale = clamshell and 1.5 or 1,
})

-- Turn off the half-panel output whenever it appears.
local function disable_ultrafine_tile(monitor)
  if monitor and monitor.description == ultrafine
    and monitor.available_modes and #monitor.available_modes == 1 then
    hl.monitor({ output = monitor.name, disabled = true })
  end
end
for _, monitor in ipairs(hl.get_monitors()) do disable_ultrafine_tile(monitor) end
hl.on("monitor.added", disable_ultrafine_tile)

-- Configure a specific monitor.
-- hl.monitor({ output = "DP-2", mode = "2560x1440@144", position = "0x0", scale = 1 })

-- Portrait/rotated secondary monitor (transform: 1 = 90°, 3 = 270°).
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
