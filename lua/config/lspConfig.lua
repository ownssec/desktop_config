local lspconfig = require("lspconfig")
local capabilities = require("blink.cmp").get_lsp_capabilities()

local on_attach = function(_, bufnr)
	local opts = { buffer = bufnr, silent = true }

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
end

-- Non-special servers
local servers = {
	"ts_ls",
	"html",
	"cssls",
	"tailwindcss",
	"eslint",
	"intelephense",
}

for _, server in ipairs(servers) do
	lspconfig[server].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

-- ✅ Lua LSP (special config ONLY here)
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,

	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},

			diagnostics = {
				globals = { "vim" },
			},

			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},

			telemetry = {
				enable = false,
			},
		},
	},
})
