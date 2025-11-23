local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font Mono",
	"Symbols Nerd Font Mono",
	"Noto Color Emoji",
})

config.font_size = 10.5

-- Transparency
config.window_background_opacity = 1
config.text_background_opacity = 1.0

-- Appearance
config.color_scheme = "Catch Me If You Can (terminal.sexy)"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

config.warn_about_missing_glyphs = false

config.freetype_load_flags = "NO_HINTING"
config.freetype_load_target = "Light"
config.line_height = 1
config.cell_width = 1

return config
