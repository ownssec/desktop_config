local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Use JetBrainsMono Nerd Font with fallbacks
config.font = wezterm.font_with_fallback({
	{ family = "JetBrainsMono Nerd Font", weight = "Regular", style = "Normal" },
	"Symbols Nerd Font Mono", -- extra glyph coverage
	"Noto Color Emoji", -- emoji support
})

config.font_size = 10.5

-- Transparency
config.window_background_opacity = 1
config.text_background_opacity = 1.0

-- Appearance
config.color_scheme = "Catch Me If You Can (terminal.sexy)"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- Disable missing glyph warnings
config.warn_about_missing_glyphs = false

return config
