local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-d>"] = actions.delete_buffer + actions.move_to_top,
				["?"] = false, -- disable Shift + /
			},
			n = {
				["<C-d>"] = actions.delete_buffer + actions.move_to_top,
				["?"] = false,
			},
		},

		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				preview_width = 0.7,
				width = 0.5,
				height = 0.5,
			},
			preview_cutoff = 0,
		},

		sorting_strategy = "ascending",
		prompt_prefix = " ",
		selection_caret = "➤ ",
		path_display = { "smart", "shorten" },

		-- highlight the selected row
		winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",

		prompt_title = "Search",
		results_title = "Results List",
		preview_title = "Preview File",
	},

	pickers = {
		find_files = {
			prompt_title = "file",
			results_title = "",
			preview_title = "",
			path_display = { "absolute" }, -- only show full paths
		},

		live_grep = {
			prompt_title = "grep",
			results_title = "",
			preview_title = "",
			path_display = { "absolute" }, -- only file paths
		},

		buffers = {
			prompt_title = "buffer",
			results_title = "",
			preview_title = "",
			path_display = { "absolute" },
		},

		help_tags = {
			prompt_title = "",
			results_title = "",
			preview_title = "",
			path_display = { "absolute" },
		},
	},
})

-- Extensions
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "file_browser")

-- CTRL + O → live grep with preview above
vim.keymap.set("n", "<C-o>", function()
	builtin.live_grep({
		winblend = 0,

		layout_strategy = "vertical",
		layout_config = {
			vertical = {
				width = 0.4, -- 50% of screen width
				height = 0.55, -- 70% of screen height
				anchor = "N", -- << THIS centers the window on screen

				prompt_position = "top",
				preview_height = 0.55, -- smaller preview
			},
		},

		sorting_strategy = "ascending",
		results_title = "",
		preview_title = "",
		path_display = { "absolute" },

		selection_caret = "➤ ",
	})
end, { noremap = true, silent = true })
