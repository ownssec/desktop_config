-- Safe require
local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

configs.setup({
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "query",
    "html",
    "http",
    "css",
    "javascript",
    "json",
    "php",
    "scss",
    "slint",
    "sql",
    "typescript",
    "tsx",
    "bash",
    "regex",
  },

  sync_install = true,
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },
})


-- local status, treesitter = pcall(require, "nvim-treesitter")
-- if not status then
-- 	return
-- end
--
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = false
--
-- require("nvim-treesitter.configs").setup({
-- 	ensure_installed = {
-- 		"lua",
-- 		"vim",
-- 		"vimdoc",
-- 		"query",
-- 		"html",
-- 		"http",
-- 		"css",
-- 		"javascript",
-- 		"json",
-- 		"php",
-- 		"scss",
-- 		"slint",
-- 		"sql",
-- 		"tsx",
-- 		"typescript",
-- 		"bash",
-- 		"regex",
-- 		"tsx",
-- 	},
-- 	sync_install = true,
-- 	auto_install = true,
--
-- 	highlight = {
-- 		enable = true,
-- 		additional_vim_regex_highlighting = false,
-- 	},
--
-- 	indent = {
-- 		enable = true,
-- 	},
-- })
--
-- -- Normal mode mapping
-- vim.api.nvim_set_keymap("n", "<C-e>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
--
-- -- Insert mode mapping
-- vim.api.nvim_set_keymap("i", "<C-e>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
