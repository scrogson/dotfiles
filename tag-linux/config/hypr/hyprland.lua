-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Omarchy's bootstrap keeps path setup out of this user config.
dofile((os.getenv("OMARCHY_PATH") or "/usr/share/omarchy") .. "/default/hypr/bootstrap.lua")

-- Disable all Omarchy default bindings. Add your own in hypr/bindings.lua.
-- omarchy_default_bindings = false
--
-- Or disable only bindings for Omarchy's preinstalled apps/web apps while
-- keeping core window-manager bindings:
-- omarchy_preinstalled_bindings = false

-- Load Omarchy defaults.
require("default.hypr.omarchy")

-- Put your personal overrides in these files. They're loaded after Omarchy's
-- defaults so package updates can improve the defaults without rewriting your
-- ~/.config/hypr files.
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")

-- Toggle config flags dynamically.
require("default.hypr.toggles")

-- Add any other personal Hyprland configuration below.
-- o.window("qemu", { workspace = "5" })

-- Tile Evince (PDF viewer). Omarchy's defaults tag it "floating-window" in
-- default/hypr/apps/system.lua; later rules win, so this overrides that.
o.window("org.gnome.Evince", { tag = "-floating-window" })
o.window("org.gnome.Evince", { tile = true })

-- Drop-down Claude Code terminal (toggled by ~/.local/bin/claude-dropdown).
o.window("org.omarchy.claude-dropdown", {
  workspace = "special:claude",
  float = true,
  size = { "(monitor_w*0.6)", "(monitor_h*0.6)" },
  move = { "(monitor_w*0.2)", "(monitor_h*0.03)" },
})

-- Pop-up qalc calculator (toggled by ~/.local/bin/calc-popup).
o.window("org.omarchy.calc-popup", {
  workspace = "special:calc",
  float = true,
  center = true,
  size = { "(monitor_w*0.3)", "(monitor_h*0.35)" },
})
