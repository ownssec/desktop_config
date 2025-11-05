local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")
local themes = require("telescope.themes")

-- Setup
telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-d>"] = actions.delete_buffer + actions.move_to_top, -- in insert mode
			},
			n = {
				["<C-d>"] = actions.delete_buffer + actions.move_to_top, -- in normal mode
			},
		},
		layout_strategy = "horizontal",
		layout_config = {
			horizontal = {
				preview_width = 0.7,
				width = 0.85,
				height = 0.85,
				-- prompt_position = "top", -- typing at the top left
			},
			preview_cutoff = 0, -- force preview to show even if window is small
			-- preview_width = 0.7, -- 60% preview pane on the right
			-- width = 0.85,
			-- height = 0.85,
		},
		sorting_strategy = "ascending",
		path_display = { "smart", "shorten" },
		prompt_prefix = " ",
		selection_caret = " ",

		prompt_title = "Search",
		results_title = "Results List",
		preview_title = "Preview File",
	},

	pickers = {
		find_files = {
			prompt_title = "file",
			results_title = "",
			preview_title = "",
		},
		live_grep = {
			prompt_title = "grep",
			results_title = "",
			preview_title = "",
		},
		buffers = {
			prompt_title = "buffer",
			results_title = "",
			preview_title = "",
		},
		help_tags = {
			prompt_title = "",
			results_title = "",
			preview_title = "",
		},
	},
})

-- Load extensions if installed
pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "file_browser")

vim.keymap.set("n", "<C-o>", function()
	local builtin = require("telescope.builtin")

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
	})
end, { noremap = true, silent = true })
