local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Use JetBrainsMono Nerd Font
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular", style = "Normal" })
config.font_size = 10.5

-- Transparency
config.window_background_opacity = 1
config.text_background_opacity = 1.0

-- Appearance
config.color_scheme = "Catch Me If You Can (terminal.sexy)"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

return config

--  https://ownssec:REDACTEDi7fPpiDIY34yRElUxFVkofHSWvdZqU0srKL2@github.com/ownssec/wezterm.git
--  https://ownssec:REDACTEDi7fPpiDIY34yRElUxFVkofHSWvdZqU0srKL2@github.com/ownssec/picom.git
