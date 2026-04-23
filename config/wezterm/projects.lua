local wezterm = require 'wezterm'
local mux = wezterm.mux
local module = {}

local ok, dirs_config = pcall(require, 'project_dirs')
local pinned = ok and dirs_config.pinned or {}

-- Build a lookup from dir path to its config
local project_config = {}
for _, entry in ipairs(pinned) do
  if type(entry) == 'table' then
    project_config[entry.dir] = entry
  end
end

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

  -- Spawn tabs and panes if configured
  local config = project_config[dir]
  if config and config.tabs then
    wezterm.time.call_after(0.5, function()
      for _, w in ipairs(mux.all_windows()) do
        if w:get_workspace() == name then
          for i, tab_config in ipairs(config.tabs) do
            local tab, first_pane
            if i == 1 then
              -- Reuse the tab created by SwitchToWorkspace
              tab = w:active_tab()
              first_pane = tab:panes()[1]
            else
              tab, first_pane = w:spawn_tab { cwd = dir }
            end
            if tab_config.title then
              tab:set_title(tab_config.title)
            end
            if tab_config.command then
              first_pane:send_text(tab_config.command .. '\n')
            end
            if tab_config.panes then
              for _, pane_config in ipairs(tab_config.panes) do
                local split_pane = first_pane:split {
                  direction = pane_config.direction or 'Right',
                  size = pane_config.size or 0.5,
                  cwd = dir,
                }
                if pane_config.command then
                  split_pane:send_text(pane_config.command .. '\n')
                end
              end
            end
          end
          -- Activate the first tab
          w:tabs()[1]:activate()
          return
        end
      end
    end)
  end
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

    -- Build the fish script
    local scriptfile = os.tmpname() .. '.fish'
    local sf = io.open(scriptfile, 'w')
    if not sf then
      return
    end

    local pinned_dirs = {}
    for _, entry in ipairs(pinned) do
      if type(entry) == 'table' then
        table.insert(pinned_dirs, entry.dir)
      else
        table.insert(pinned_dirs, entry)
      end
    end
    local pinned_str = table.concat(pinned_dirs, '\n')

    local active_list = {}
    for name, _ in pairs(active_workspaces) do
      table.insert(active_list, name)
    end
    local active_str = table.concat(active_list, '\n')

    sf:write([[
# Get all project dirs
set dirs (printf '%s\n' ]] .. wezterm.shell_quote_arg(pinned_str) .. [[ | sort -u)

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
