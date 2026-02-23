-- lua/configs/wilder.lua

local bgColor = "#191616"
local bgHighLight = "#6e7073"
-- local bgColor = "#181818"
local fgImportant = "#5a747d"
vim.o.background = "dark"

vim.cmd.colorscheme("zenwritten")

vim.api.nvim_set_hl(0, "Keyword", { fg = fgImportant, bold = true })
vim.api.nvim_set_hl(0, "Statement", { fg = fgImportant })
-- vim.api.nvim_set_hl(0, "Normal", { bg = bgColor, fg = "#a3a19e" })
vim.api.nvim_set_hl(0, "Normal", { bg = bgColor, fg = "#a3a19e" })
vim.api.nvim_set_hl(0, "LineNr", { bg = bgColor, fg = "#a3a19e" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = bgColor })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = bgColor, fg = "#dedede", bold = true })
vim.api.nvim_set_hl(0, "String", { fg = "#977C71" })

-- Change the background color of the command line input area
vim.api.nvim_set_hl(0, "Cmdline", { bg = bgColor, fg = "#ffffff" })

-- Change the background color of the popup menu (suggestions list)
vim.api.nvim_set_hl(0, "Pmenu", { bg = bgColor, fg = "#c0c0c0" })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = bgHighLight, fg = "#ffffff" }) -- selected item
vim.api.nvim_set_hl(0, "PmenuSbar", { bg = bgHighLight }) -- scrollbar
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = bgHighLight }) -- scrollbar thumb
-- For init.lua
-- vim.opt.guicursor = "n-v-c:block-Cursor"
-- vim.api.nvim_set_hl(0, "Cursor", { fg = "#FFFFFF", bg = "#FFFFFF" })
