-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Macchiato'
config.font =
  wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true })
config.font_size = 13.0

config.window_frame = {
  font = wezterm.font('JetBrains Mono', { weight = 'Bold', italic = true }),
  active_titlebar_bg = '#2B2B2B',
}

-- and finally, return the configuration to wezterm
return config
