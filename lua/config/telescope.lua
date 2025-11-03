local telescope = require("telescope")
local builtin = require("telescope.builtin")
local actions = require("telescope.actions")

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
			prompt_position = "top", -- typing at the top left
			preview_width = 0.7, -- 60% preview pane on the right
			width = 0.85,
			height = 0.85,
			preview_cutoff = 0, -- force preview to show even if window is small
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

-- Keymaps
-- vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Find Files" })
vim.keymap.set("n", "<C-o>", builtin.live_grep, { desc = "Live Grep" })
-- vim.keymap.set("n", "<C-i>", builtin.buffers, { desc = "List Buffers" })

vim.keymap.set("n", "[ct", function()
	local current = vim.api.nvim_get_current_buf()
	local buffers = vim.api.nvim_list_bufs()

	for _, buf in ipairs(buffers) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
			if buf ~= current then
				vim.cmd("bdelete " .. buf)
			end
		end
	end
end, { desc = "Delete all buffers except current" })

-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
-- vim.keymap.set("n", "<leader>fe", ":Telescope file_browser<CR>", { desc = "File Browser" })
