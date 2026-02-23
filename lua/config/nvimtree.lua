local status, treesitter = pcall(require, "nvim-tree")
if not status then
	return
end

local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end

	-- Set default mappings from nvim-tree
	api.config.mappings.default_on_attach(bufnr)

	-- Custom key mappings
	vim.keymap.set("n", "<C-e>", api.tree.toggle, opts("Toggle Tree"))
	vim.keymap.set("n", "f", api.tree.toggle_help, opts("Toggle Help"))
end

require("nvim-tree").setup({
	on_attach = my_on_attach,
	view = {
		width = 60,
		number = true,
		side = "right",
		relativenumber = true,
	},
	renderer = {
		group_empty = true,
		highlight_modified = "all",
		highlight_git = true,

		root_folder_label = false,
	},
	filters = {
		dotfiles = false,
		git_clean = false,
		no_buffer = false,
		custom = { "node_modules" },
		exclude = { ".env" },
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
	},
	diagnostics = {
		enable = true,
	},
})

vim.cmd("autocmd VimEnter * hi NvimTreeNormal guibg=#191616")
vim.cmd("autocmd VimEnter * hi NvimTreeNormalNC guibg=#191616")
