-- Extra autostart processes.
-- o.launch_on_start("my-service")

-- Apply light/dark theme for the current time of day (see ~/.local/bin/theme-auto)
o.launch_on_start("theme-auto")

-- Sunshine game-stream host (remote control from Moonlight)
o.launch_on_start("sunshine")

-- Cloudflare Tunnel for *.localroster.dev (~/.cloudflared/config.yml)
o.launch_on_start("cloudflared tunnel run localroster")

-- iMessage Bridge client (~/github.com/scrogson/blueballs); reconnects to the Mac on its own
o.launch_on_start("imessage-bridge")
