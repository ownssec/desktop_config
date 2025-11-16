-- lua/configs/lualine.lua
local ok, lualine = pcall(require, "lualine")
if not ok then
	return
end

-- Colors
local fg_main = "#a6a6a6" -- light gray text
local bg_main = "none" -- dark background

-- Theme with background
local themed = {
	a = { fg = fg_main, bg = bg_main },
	b = { fg = fg_main, bg = bg_main },
	c = { fg = fg_main, bg = bg_main },
}

lualine.setup({
	options = {
		icons_enabled = false,
		theme = {
			normal = themed,
			insert = themed,
			visual = themed,
			replace = themed,
			command = themed,
			inactive = themed,
		},
		component_separators = "::",
		section_separators = "",
	},

	sections = {
		lualine_a = { "mode" },

		lualine_b = {
			"filename",
			"location",
			"progress",
			{
				function()
					local branch = vim.b.gitsigns_head
					return (branch and branch ~= "") and ("**" .. branch .. "**") or ""
				end,
			},
		},

		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},

	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
})

-- Sync StatusLine highlight
vim.api.nvim_set_hl(0, "StatusLine", { bg = bg_main, fg = fg_main })
vim.api.nvim_set_hl(0, "StatusLineNC", { bg = bg_main, fg = fg_main })
