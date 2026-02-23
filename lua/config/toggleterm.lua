local status, toggleterm = pcall(require, "toggleterm")

if not status then
	return
end

local bgColor = "#191616"

toggleterm.setup({
	shade_terminals = true,
	-- direction = "horizontal",
	direction = "float",
	size = function(term)
		if term.direction == "horizontal" then
			return vim.o.columns * 0.09
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.4
		end
	end,
	float_opts = {
		border = "single",
		width = function()
			return math.floor(vim.o.columns * 0.8) -- 80% of editor width
		end,
		height = function()
			return math.floor(vim.o.lines * 0.8) -- 80% of editor height
		end,
		row = function()
			return math.floor((vim.o.lines - (vim.o.lines * 0.8)) / 2)
		end,
		col = function()
			return math.floor((vim.o.columns - (vim.o.columns * 0.8)) / 2)
		end,
		winblend = 3,
		zindex = 1,
		title_pos = "center",
	},
	start_in_insert = true,
	winbar = {
		enabled = false,
		name_formatter = function(term) --  term: Terminal
			return term.name
		end,
	},
	shading_factor = 1,
})

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "term://*",
	callback = function()
		vim.opt.relativenumber = true -- Enable relative line numbers
		vim.opt.number = true -- Enable absolute line numbers
		vim.opt.signcolumn = "yes" -- Ensure the sign column is always visible
	end,
})

local keymap_opts = { noremap = true, silent = true }

-- Keep the existing keybindings for terminals 1-4
for i = 1, 4 do
	vim.api.nvim_set_keymap("n", "[" .. i, "<Cmd>exe 'ToggleTerm " .. i .. "'<CR>", keymap_opts)
	vim.api.nvim_set_keymap("i", "[" .. i, "<Esc><Cmd>exe 'ToggleTerm " .. i .. "'<CR>", keymap_opts)
	vim.api.nvim_set_keymap("t", "[" .. i, "<Cmd>exe 'ToggleTerm " .. i .. "'<CR>", keymap_opts)
end

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

-- Autocommand to set keymaps for terminal buffers
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- 💡 Force background on all relevant groups
local function set_toggleterm_highlights()
	vim.cmd("highlight! TermNormal guibg=" .. bgColor .. " guifg=NONE")
	vim.cmd("highlight! TermNormalNC guibg=" .. bgColor .. " guifg=NONE")
	vim.cmd("highlight! NormalFloat guibg=" .. bgColor .. " guifg=NONE")
	vim.cmd("highlight! FloatBorder guibg=" .. bgColor .. " guifg=#878787")
end

-- Apply once now
set_toggleterm_highlights()

-- Re-apply on colorscheme change to make it permanent
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = set_toggleterm_highlights,
})

-- local status, toggleterm = pcall(require, "toggleterm")
-- local Terminal = require("toggleterm.terminal").Terminal
--
-- if not status then
-- 	return
-- end
--
-- local bgColor = "#191616"
--
-- -- Track the currently active terminal
-- local current_term = nil
--
-- local function open_term(id)
-- 	-- If the same terminal is already active and open → close it
-- 	if current_term and current_term.id == id and current_term:is_open() then
-- 		current_term:close()
-- 		current_term = nil
-- 		return
-- 	end
--
-- 	-- If another terminal is open → close it
-- 	if current_term and current_term:is_open() then
-- 		current_term:close()
-- 	end
--
-- 	-- Open the requested terminal
-- 	current_term = Terminal:new({ id = id })
-- 	current_term:toggle()
-- end
--
-- toggleterm.setup({
-- 	shade_terminals = true,
-- 	direction = "horizontal",
-- 	-- direction = "float",
-- 	size = function(term)
-- 		if term.direction == "horizontal" then
-- 			return vim.o.columns * 0.09
-- 		elseif term.direction == "vertical" then
-- 			return vim.o.columns * 0.4
-- 		end
-- 	end,
--
-- 	start_in_insert = true,
-- 	winbar = {
-- 		enabled = false,
-- 		name_formatter = function(term) --  term: Terminal
-- 			return term.name
-- 		end,
-- 	},
-- 	shading_factor = 1,
-- 	responsiveness = {
-- 		-- breakpoint in terms of `vim.o.columns` at which terminals will start to stack on top of each other
-- 		-- instead of next to each other
-- 		-- default = 0 which means the feature is turned off
-- 		horizontal_breakpoint = 135,
-- 	},
-- 	highlights = {
-- 		Normal = {
-- 			guibg = bgColor,
-- 		},
-- 	},
-- 	on_open = function(term)
-- 		if term.direction == "horizontal" then
-- 			local width = vim.api.nvim_win_get_width(term.window)
-- 			local border = string.rep(".", width) -- You can use "─", "═", "▔", etc.
--
-- 			-- Set the winbar with proper highlighting
-- 			vim.api.nvim_win_set_option(term.window, "winbar", "%#ToggleTermBorderRed#" .. border)
--
-- 			-- Alternative approach that might work better in some cases:
-- 			-- vim.api.nvim_win_set_option(term.window, "winbar", border)
-- 			-- vim.api.nvim_win_set_option(term.window, "winhl", "WinBar:ToggleTermBorderRed")
-- 		end
-- 	end, -- Optional: Clear the border when terminal closes
-- 	on_close = function(term)
-- 		if term.direction == "horizontal" then
-- 			vim.api.nvim_win_set_option(term.window, "winbar", "")
-- 		end
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("TermOpen", {
-- 	pattern = "term://*",
-- 	callback = function()
-- 		vim.opt.relativenumber = true -- Enable relative line numbers
-- 		vim.opt.number = true -- Enable absolute line numbers
-- 		vim.opt.signcolumn = "yes" -- Ensure the sign column is always visible
-- 	end,
-- })
--
-- local keymap_opts = { noremap = true, silent = true }
--
-- -- Ensure the leader key is set (usually Space)
-- vim.g.mapleader = "["
--
-- for i = 1, 4 do
-- 	vim.keymap.set("n", "<Leader>" .. i, function()
-- 		open_term(i)
-- 	end, keymap_opts)
--
-- 	vim.keymap.set("i", "<Leader>" .. i, function()
-- 		vim.cmd("stopinsert")
-- 		open_term(i)
-- 	end, keymap_opts)
--
-- 	vim.keymap.set("t", "<Leader>" .. i, function()
-- 		open_term(i)
-- 	end, keymap_opts)
-- end
--
-- function _G.set_terminal_keymaps()
-- 	local opts = { buffer = 0 }
-- 	vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
-- 	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
-- 	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
-- 	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
-- 	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
-- end
--
-- -- Autocommand to set keymaps for terminal buffers
-- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
--
-- -- 💡 Force background on all relevant groups
-- local function set_toggleterm_highlights()
-- 	vim.cmd("highlight! TermNormal guibg=" .. bgColor .. " guifg=NONE")
-- 	vim.cmd("highlight! TermNormalNC guibg=" .. bgColor .. " guifg=NONE")
-- 	vim.cmd("highlight! NormalFloat guibg=" .. bgColor .. " guifg=NONE")
-- 	vim.cmd("highlight! FloatBorder guibg=" .. bgColor .. " guifg=#878787")
-- end
--
-- -- Apply once now
-- set_toggleterm_highlights()
--
-- -- Re-apply on colorscheme change to make it permanent
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- 	pattern = "*",
-- 	callback = set_toggleterm_highlights,
-- })
