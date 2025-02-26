-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.color_scheme = 'Dracula+'
config.font =
  wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })
config.font_size = 13.0
config.window_frame = {
  font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true }),
  active_titlebar_bg = '#2B2B2B',
}

config.tab_bar_at_bottom = true

config.leader = { key = 'q', mods = 'CTRL' }
config.keys = {
  {
    key = 'v',
    mods = 'LEADER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'h',
    mods = 'LEADER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
}

-- and finally, return the configuration to wezterm
return config
