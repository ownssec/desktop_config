local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		preview_cutoff = 0,
		sorting_strategy = "ascending",
		prompt_prefix = " ",
		selection_caret = "➤ ",
		path_display = { "smart" },

		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				preview_width = 0,
				width = 0,
				height = 0,
			},
			preview_cutoff = 0,
		},
	},

	pickers = {

		-- 🟩 LIVE GREP — preview at the BOTTOM (your request)
		----------------------------------------------------------------------------
		-- live_grep = {
		-- 	layout_strategy = "vertical",
		-- 	layout_config = {
		-- 		vertical = {
		-- 			prompt_position = "top", -- SEARCH INPUT at TOP
		-- 			mirror = true, -- PREVIEW BELOW RESULTS (THE KEY)
		-- 			preview_height = 0, -- preview size
		-- 			width = 0,
		-- 			height = 0,
		-- 		},
		-- 		preview_cutoff = 0, -- always show preview
		-- 	},
		-- 	prompt_title = "grep",
		-- 	results_title = "",
		-- 	preview_title = "",
		-- 	path_display = { "absolute" },
		-- },
	},
})

-- Your CTRL+O custom mapping for live grep layout
vim.keymap.set("n", "<C-o>", function()
	require("telescope.builtin").live_grep({
		layout_strategy = "vertical",

		layout_config = {
			-- 🔒 FIX WINDOW POSITION (ALWAYS CENTERED)
			anchor = "CENTER",

			-- 🔒 FIX WINDOW SIZE (THIS MAKES POSITION STABLE)
			width = 0.35, -- 60% of screen width
			height = 0.35, -- 80% of screen height

			-- 🔒 INTERNAL LAYOUT
			vertical = {
				prompt_position = "top",
				mirror = true, -- preview at bottom
				preview_height = 0.65, -- adjust freely without moving popup
			},

			preview_cutoff = 0,
		},

		sorting_strategy = "ascending",
		path_display = { "absolute" },
		results_title = "",
		preview_title = "",
	})
end, { noremap = true, silent = true })
