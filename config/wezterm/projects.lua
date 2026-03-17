local wezterm = require 'wezterm'
local mux = wezterm.mux
local module = {}

local ok, dirs_config = pcall(require, 'project_dirs')
local search_dirs = ok and dirs_config.search_dirs or {}
local pinned = ok and dirs_config.pinned or {}

module.caller_pane_id = nil

local function switch_to_dir(window, pane, dir)
  local name = dir:match '([^/]+)$'
  local all_workspaces = mux.get_workspace_names()

  for _, ws in ipairs(all_workspaces) do
    if ws == name then
      window:perform_action(wezterm.action.SwitchToWorkspace { name = name }, pane)
      return
    end
  end

  window:perform_action(
    wezterm.action.SwitchToWorkspace {
      name = name,
      spawn = { cwd = dir },
    },
    pane
  )
end

module.switch_to_dir = switch_to_dir

function module.create_from_path()
  return wezterm.action.PromptInputLine {
    description = 'Enter path for new workspace:',
    action = wezterm.action_callback(function(window, pane, line)
      if not line or #line == 0 then
        return
      end
      local dir = line:gsub('^~', wezterm.home_dir)
      local name = dir:match '([^/]+)$'
      window:perform_action(
        wezterm.action.SwitchToWorkspace {
          name = name,
          spawn = { cwd = dir },
        },
        pane
      )
    end),
  }
end

function module.show_picker()
  return wezterm.action_callback(function(window, pane)
    local active_workspaces = {}
    for _, name in ipairs(mux.get_workspace_names()) do
      active_workspaces[name] = true
    end

    -- Build find command to list project directories
    local find_parts = {}
    for _, dir in ipairs(search_dirs) do
      table.insert(find_parts, string.format('find %q -mindepth 1 -maxdepth 1 -type d 2>/dev/null', dir))
    end
    local find_cmd = table.concat(find_parts, '; ')

    -- Build the fish script
    local scriptfile = os.tmpname() .. '.fish'
    local sf = io.open(scriptfile, 'w')
    if not sf then
      return
    end

    local pinned_str = table.concat(pinned, '\n')

    local active_list = {}
    for name, _ in pairs(active_workspaces) do
      table.insert(active_list, name)
    end
    local active_str = table.concat(active_list, '\n')

    sf:write([[
# Get all project dirs
set dirs (begin
  printf '%s\n' ]] .. wezterm.shell_quote_arg(pinned_str) .. [[

  ]] .. find_cmd .. [[

end | sort -u)

# Active workspaces
set active_ws ]] .. wezterm.shell_quote_arg(active_str) .. [[


# Format entries: "indicator name<TAB>dir"
set tab (printf '\t')
set entries
for dir in $dirs
  set name (basename $dir)
  set indicator "○"
  for ws in (string split \n $active_ws)
    if test "$ws" = "$name"
      set indicator "●"
      break
    end
  end
  set -a entries "$indicator $name$tab$dir"
end

set selected (printf '%s\n' $entries | fzf \
  --ansi \
  --delimiter=$tab \
  --with-nth=1 \
  --layout=reverse \
  --prompt="Project> " \
  --pointer="❯" \
  --header="Select a project workspace")

rm -f "]] .. scriptfile .. [["

if test -n "$selected"
  set dir (string split $tab $selected)[2]
  set encoded (printf '%s' "$dir" | base64 | tr -d '\n')
  printf "\033]1337;SetUserVar=%s=%s\007" project_dir "$encoded"
  sleep 0.1
end
]])
    sf:close()

    module.caller_pane_id = pane:pane_id()

    -- Unzoom if currently zoomed so we can split
    local tab = pane:tab()
    if tab then
      for _, p in ipairs(tab:panes_with_info()) do
        if p.is_zoomed then
          window:perform_action(wezterm.action.TogglePaneZoomState, pane)
          break
        end
      end
    end

    local fzf_pane = pane:split {
      direction = 'Bottom',
      size = 0.4,
      top_level = true,
      args = { '/opt/homebrew/bin/fish', scriptfile },
    }

    fzf_pane:activate()
    window:perform_action(wezterm.action.TogglePaneZoomState, fzf_pane)
  end)
end

return module
