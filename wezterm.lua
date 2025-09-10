local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Correct rasterizer and shaper for crisp fonts
config.font_rasterizer = "FreeType"
config.font_shaper = "Harfbuzz"

-- Font settings
config.font = wezterm.font("JetBrains Mono", {
	weight = "Regular",
	stretch = "Normal",
	style = "Normal",
})
config.font_size = 10.8
config.dpi = 96.0

-- Appearance
config.color_scheme = "Catch Me If You Can (terminal.sexy)"
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.max_fps = 240
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

return config

--  https://ownssec:REDACTEDi7fPpiDIY34yRElUxFVkofHSWvdZqU0srKL2@github.com/ownssec/wezterm.git
