-- Your existing Neovim config

vim.g.db_ui_use_vertical_split = 1
-- Global Neovim setting to prefer right-side splits
vim.opt.splitright = true

require("plugins")
require("settings")
require("keymap")

-- custom functions
require("config.customBufferLists")
-- require("config.customLiveGrep")
-- require("config.customLiveGrep")

local bgColor = "#191616"

-- Function to force background highlights
local function force_bg_highlights()
	vim.cmd("highlight! NvimTreeNormal guibg=" .. bgColor .. " guifg=NONE")
	vim.cmd("highlight! NvimTreeNormalNC guibg=" .. bgColor .. " guifg=NONE")
	vim.cmd("highlight! TermNormal guibg=" .. bgColor .. " guifg=NONE")
	vim.cmd("highlight! TermNormalNC guibg=" .. bgColor .. " guifg=NONE")
	vim.cmd("highlight! NormalFloat guibg=" .. bgColor .. " guifg=NONE")
end

-- Apply now
force_bg_highlights()

-- Re-apply on ColorScheme change to prevent overrides
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		force_bg_highlights()
	end,
})

vim.lsp.set_log_level("off") -- Disable LSP logging
vim.g.neo_tree_log_to_file = 0 -- Disable NeoTree logs (if using NeoTree)
vim.g.loaded_netrwPlugin = 2 -- Disable file explorer logs (if applicable)

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local log_path = vim.fn.expand(".nvimlog")
		if vim.fn.filereadable(log_path) == 1 then
			os.remove(log_path)
		end
	end,
})

vim.cmd([[
  hi Normal guibg=NONE ctermbg=NONE
  hi NormalNC guibg=NONE ctermbg=NONE
]])

-- mongodb
vim.g.dbs = {
    portal_atlas = "mongodb+srv://admin101:admin101@portalproposaltest.9100stb.mongodb.net/test",
}

-- http kulala
vim.api.nvim_create_autocmd("FileType", {
  pattern = "kulala_http",
  callback = function()
    vim.bo.filetype = "http"
  end,
})

-- windows config
-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"
-- WSL clipboard integration that automatically removes Windows ^M characters
if vim.fn.has("wsl") == 1 then
    vim.g.clipboard = {
        name = "WslClipboard",
        copy = {
            ["+"] = "clip.exe",
            ["*"] = "clip.exe",
        },
        paste = {
            -- Uses PowerShell to grab clipboard and instantly strip the \r (carriage return)
            ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
end
