local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-d>"] = actions.delete_buffer + actions.move_to_top,
			},
			n = {
				["<C-d>"] = actions.delete_buffer + actions.move_to_top,
			},
		},

		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				preview_width = 0.7,
				width = 0.85,
				height = 0.85,
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
		winblend = 10,
		layout_strategy = "vertical",
		layout_config = {
			vertical = {
				width = 0.3,
				height = 0.8,
				anchor = "center",
				prompt_position = "top",
				preview_height = 0.28,
			},
		},
		sorting_strategy = "ascending",
		results_title = "",
		preview_title = "",
		path_display = { "absolute" }, -- only file paths

		-- highlight selection
		selection_caret = "➤ ",
		-- winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
	})
end, { noremap = true, silent = true })
