require("blink.cmp").setup({
	keymap = {
		preset = "super-tab",
	},

	appearance = {
		nerd_font_variant = "mono",
	},

	completion = {
		menu = {
			auto_show = true,
		},
		documentation = {
			auto_show = false,
		},
	},

	sources = {
		default = {
			"lsp",
			"path",
			"snippets",
			"buffer",
		},
	},

	snippets = {
		preset = "luasnip",
	},

	fuzzy = {
		implementation = "prefer_rust",
	},
})
