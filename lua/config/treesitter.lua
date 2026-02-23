-- Safe require
local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  return
end

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

