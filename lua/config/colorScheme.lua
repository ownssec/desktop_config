-- working
-- lua/configs/colorScheme.lua
local bgColor = "#191616"
local bgHighLight = "#6e7073"
local fgImportant = "#5a747d"
local fgString = "#977C71"
local fgNormal = "#9c9992"

local fgFunction = "#adadad"

vim.o.background = "dark"

vim.cmd.colorscheme("zenwritten")

vim.api.nvim_set_hl(0, "Keyword", { fg = fgImportant, bold = true })
vim.api.nvim_set_hl(0, "Statement", { fg = fgImportant })
vim.api.nvim_set_hl(0, "Normal", { bg = bgColor, fg = fgNormal })
vim.api.nvim_set_hl(0, "LineNr", { bg = bgColor, fg = fgNormal })
vim.api.nvim_set_hl(0, "SignColumn", { bg = bgColor })
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = bgColor, fg = fgImportant, bold = true })
vim.api.nvim_set_hl(0, "String", { fg = fgString })

vim.api.nvim_set_hl(0, "Cmdline", { bg = bgColor, fg = fgImportant })

vim.api.nvim_set_hl(0, "Pmenu", { bg = bgColor, fg = fgImportant })
vim.api.nvim_set_hl(0, "PmenuSel", { bg = bgHighLight, fg = fgImportant }) -- selected item
vim.api.nvim_set_hl(0, "PmenuSbar", { bg = bgHighLight }) -- scrollbar
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = bgHighLight }) -- scrollbar thumb

local function highlight_functions(color, is_bold)
	local groups = {
		"Function",
		"@function",
		"@function.call",
		"@function.method",
		"@function.method.call", -- This targets: buildEstimateController.METHOD_NAME
		"@method",
		"@method.call",
		"@constructor", -- This targets: express()
		"@function.builtin", -- This targets: console.log, setTimeout, etc.
	}
	for _, group in ipairs(groups) do
		vim.api.nvim_set_hl(0, group, { fg = color, bold = is_bold, force = true })
	end
end

-- Call the force highlight function
highlight_functions(fgFunction, true)
