-- lua/configs/kulala.lua

require("kulala").setup({
	debug = true,
	default_env = "dev",
	ui = {
		default_winbar_panes = { "body", "verbose", "report" },
		winbar = true,
		disable_news_popup = false,
		display_mode = "split", -- float / split
		max_response_size = 1132768,
		disable_script_print_output = true,
	},
	lsp = {
		-- enable/disable built-in LSP server
		enable = true,

		-- filetypes to attach Kulala LSP to
		filetypes = { "http", "rest", "json", "yaml", "bruno" },

		--enable/disable/customize  LSP keymaps
		---@type boolean|table
		keymaps = false, -- disabled by default, as Kulala relies on default Neovim LSP keymaps

		-- enable/disable/customize HTTP formatter
		formatter = {
			sort = { -- enable/disable alphabetical sorting in request body
				metadata = true,
				variables = true,
				commands = false,
				json = true,
			},
			quote_json_variables = true, -- add quotes around {{variable}} in JSON bodies
			indent = 2, -- base indentation for scripts
		},

		on_attach = nil, -- function called when Kulala LSP attaches to the buffer
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "http", -- Adjust this to match the file type used by kulala
	callback = function()
		vim.api.nvim_set_keymap(
			"n",
			"[[",
			":lua require('kulala').jump_prev()<CR>",
			{ noremap = true, silent = true, desc = "Jump to the previous request" }
		)

		vim.api.nvim_set_keymap(
			"n",
			"[o",
			":lua require('kulala').open()<CR>",
			{ noremap = true, silent = true, desc = "Jump to the previous request" }
		)

		vim.api.nvim_set_keymap(
			"n",
			"]]",
			":lua require('kulala').jump_next()<CR>",
			{ noremap = true, silent = true, desc = "Jump to the previous request" }
		)

		vim.api.nvim_set_keymap(
			"n",
			"[r",
			"<cmd>lua require('kulala').run()<CR>",
			{ noremap = true, silent = true, desc = "Execute the request with Kulala" }
		)

		vim.api.nvim_set_keymap(
			"n",
			"[d",
			"<cmd>lua require('kulala').set_selected_env('dev')<CR>",
			{ noremap = true, silent = true, desc = "Select environment with Kulala" }
		)
		-- vim.api.nvim_set_keymap(
		-- 	"n",
		-- 	"[t",
		-- 	"<cmd>lua require('kulala').set_selected_env('testing')<CR>",
		-- 	{ noremap = true, silent = true, desc = "Select environment with Kulala" }
		-- )
		vim.api.nvim_set_keymap(
			"n",
			"[s",
			"<cmd>lua require('kulala').set_selected_env('staging')<CR>",
			{ noremap = true, silent = true, desc = "Select environment with Kulala" }
		)
		vim.api.nvim_set_keymap(
			"n",
			"[p",
			"<cmd>lua require('kulala').set_selected_env('prod')<CR>",
			{ noremap = true, silent = true, desc = "Select environment with Kulala" }
		)
		vim.api.nvim_set_keymap(
			"n",
			"[a",
			"<cmd>lua require('kulala').run_all()<CR>",
			{ noremap = true, silent = true, desc = "Send all requests with Kulala" }
		)
	end,
})

-- vim.api.nvim_create_autocmd("BufWinEnter", {
-- 	callback = function()
-- 		local bufname = vim.api.nvim_buf_get_name(0) -- Get full buffer name (with path)
-- 		if vim.fn.fnamemodify(bufname, ":t") == "ui" then -- Extract filename and check
-- 			vim.cmd("vertical resize 80")
-- 		end
-- 	end,
-- })
