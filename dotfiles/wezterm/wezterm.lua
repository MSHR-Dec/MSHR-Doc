-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

function merge_config(config, new_config)
  for k, v in pairs(new_config) do
    config[k] = v
  end
end

-- This is where you actually apply your config choices
config.use_ime = true
config.status_update_interval = 50000

config.color_scheme = 'JetBrains Darcula'
config.font = wezterm.font('JetBrains Mono')
config.font_size = 12.0
config.window_frame = {
  font = wezterm.font('JetBrains Mono', { italic = true }),
  active_titlebar_bg = '#2B2B2B',
}

config.tab_bar_at_bottom = true

local act = wezterm.action

wezterm.on('update-right-status', function(window, pane)
  window:set_right_status(window:active_workspace())
end)

config.leader = { key = 'q', mods = 'CTRL' }
config.keys = {
  {
    key = 'v',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 's',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  { key = "h", mods = "LEADER|CTRL", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER|CTRL", action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER|CTRL", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER|CTRL", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = 'c', mods = 'ALT', action = wezterm.action.CopyTo 'Clipboard' },
  { key = 'v', mods = 'ALT', action = wezterm.action.PasteFrom 'Clipboard' },
  {
    key = 'c',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = 'Bold' } },
        { Foreground = { AnsiColor = 'Fuchsia' } },
        { Text = 'Enter name for new workspace' },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:perform_action(
            act.SwitchToWorkspace {
              name = line,
            },
            pane
          )
        end
      end),
    },
  },
  {
    key = 'w',
    mods = 'LEADER',
    action = act.ShowLauncherArgs {
      flags = 'FUZZY|WORKSPACES',
    },
  },
  { key = 'n', mods = 'LEADER|CTRL', action = act.SwitchWorkspaceRelative(1) },
  { key = 'p', mods = 'LEADER|CTRL', action = act.SwitchWorkspaceRelative(-1) },
  { key = '[', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
  {
    key = 't',
    mods = 'ALT',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#696969"
  local foreground = "#FFFFFF"

  if tab.is_active then
    background = "#8b008b"
    foreground = "#FFFFFF"
  end

  local title = "   " .. wezterm.truncate_right(tab.active_pane.title, max_width - 1) .. "   "

  return {
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
  }
end)

wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    local cwd = ''
    local hostname = ''

    if type(cwd_uri) == 'userdata' then
      -- Running on a newer version of wezterm and we have
      -- a URL object here, making this simple!

      cwd = cwd_uri.file_path
      hostname = cwd_uri.host or wezterm.hostname()
    else
      -- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
      -- which doesn't have the Url object
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find '/'
      if slash then
        hostname = cwd_uri:sub(1, slash - 1)
        -- and extract the cwd from the uri, decoding %-encoding
        cwd = cwd_uri:sub(slash):gsub('%%(%x%x)', function(hex)
          return string.char(tonumber(hex, 16))
        end)
      end
    end

    -- Remove the domain name portion of the hostname
    local dot = hostname:find '[.]'
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == '' then
      hostname = wezterm.hostname()
    end

    local home = os.getenv("HOME")
    if home and cwd:sub(1, #home) == home then
      cwd = "~" .. cwd:sub(#home + 1)
    end

    -- Shorten path: keep first letter of each directory except the last one
    local function shorten_path(path)
      local parts = {}
      local is_home = path:sub(1, 1) == "~"
      local start_idx = is_home and 2 or 1
      
      -- Split path by /
      for part in path:sub(start_idx):gmatch("[^/]+") do
        table.insert(parts, part)
      end
      
      -- Shorten all but the last directory
      for i = 1, #parts - 1 do
        parts[i] = parts[i]:sub(1, 1)
      end
      
      -- Reconstruct path
      local result = is_home and "~/" or "/"
      result = result .. table.concat(parts, "/")
      
      -- Add trailing slash if original had one
      if path:sub(-1) == "/" and result:sub(-1) ~= "/" then
        result = result .. "/"
      end
      
      return result
    end
    
    cwd = shorten_path(cwd)

    table.insert(cells, cwd)
    table.insert(cells, hostname)
  end

  -- Get list of workspaces using wezterm cli
  local active_workspace = window:active_workspace()
  local workspaces = {}
  local workspace_str = ""
  
  -- Run wezterm cli list to get all workspaces
  local success, stdout, stderr = wezterm.run_child_process({"wezterm", "cli", "list", "--format", "json"})
  
  if success then
    -- Parse JSON output to extract unique workspaces
    local ok, json_data = pcall(wezterm.json_parse, stdout)
    if ok and json_data then
      local unique_workspaces = {}
      for _, entry in ipairs(json_data) do
        if entry.workspace then
          unique_workspaces[entry.workspace] = true
        end
      end
      
      -- Convert to sorted list
      for workspace, _ in pairs(unique_workspaces) do
        table.insert(workspaces, workspace)
      end
      table.sort(workspaces)
      
      -- Format workspace list with current workspace highlighted
      local workspace_list = {}
      for _, ws in ipairs(workspaces) do
        if ws == active_workspace then
          table.insert(workspace_list, "[" .. ws .. "]")
        else
          table.insert(workspace_list, ws)
        end
      end
      
      workspace_str = table.concat(workspace_list, " | ")
    end
  end
  
  -- If we couldn't get the list, just show current workspace
  if workspace_str == "" then
    workspace_str = "[" .. active_workspace .. "]"
  end
  
  table.insert(cells, workspace_str)

  -- The powerline < symbol
  local LEFT_ARROW = utf8.char(0xe0b3)
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Color palette for the backgrounds of each cell
  local colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  -- Foreground color for the text across the fade
  local text_fg = '#c0c0c0'

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

local custom = require("/custom")
merge_config(config, custom)

-- and finally, return the configuration to wezterm
return config
