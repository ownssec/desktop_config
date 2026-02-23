-- lua/configs/gitsigns.lua (or consider renaming to conform.lua for clarity)

local status, conform = pcall(require, "conform")
if not status then
	return
end

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" }, -- For .jsx files
		typescript = { "prettier" },
		typescriptreact = { "prettier" }, -- For .tsx files
		php = { "phpcbf" },
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		json = { "jq" },
	},
	formatters = {
		prettier = {
			prepend_args = {
				"--tab-width",
				"2", -- Set tab spacing to 2 spaces
				"--use-tabs",
				"false", -- Force spaces instead of tabs
				"--print-width",
				"80", -- Set line width to 80 characters
			},
		},
		kulala = {
			command = "kulala-fmt",
			args = { "format", "$FILENAME" },
			stdin = false,
		},
		jq = {
			command = "jq",
			args = { "." },
			stdin = true,
		},
		["blade-formatter"] = {
			prepend_args = { "--indent-size", "2" },
		},
	},
	format_on_save = {
		timeout_ms = 650,
		lsp_fallback = false,
	},
})
