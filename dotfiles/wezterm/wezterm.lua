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
use_ime = true

config.color_scheme = 'Dracula+'
config.color_schemes = { ['Dracula+'] = { background = '#2B2B2B' }}
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
  { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
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
  { key = 'n', mods = 'LEADER', action = act.SwitchWorkspaceRelative(1) },
  { key = 'p', mods = 'LEADER', action = act.SwitchWorkspaceRelative(-1) },
}

local custom = require("/custom")
merge_config(config, custom)

-- and finally, return the configuration to wezterm
return config
