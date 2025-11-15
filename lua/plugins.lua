-- -- lua/plugins.lua

-- Automatically run: PackerCompile
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("PACKER", { clear = true }),
	pattern = "plugins.lua",
	command = "source <afile> | PackerCompile",
})

return require("packer").startup(function(use)
	-- Package Manager
	use("wbthomason/packer.nvim")

	-- Core Utilities
	use("nvim-lua/plenary.nvim")
	use("nvim-tree/nvim-web-devicons") -- Icons

	-- LSP and Completion
	use({
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	})

	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		opt = false,
		config = function()
			require("config.cmpconf")
		end,
	})

	use({
		"neovim/nvim-lspconfig",
		after = "nvim-cmp",
		config = function()
			require("config.lsp")
		end,
	})

	use("onsails/lspkind-nvim")

	-- Syntax and Language Support
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			require("nvim-treesitter.install").update({ with_sync = true })
		end,
		config = function()
			require("config.treesitter")
		end,
	})
	use({
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascriptreact", "typescriptreact", "javascript", "typescript", "tsx" },
		config = function()
			require("nvim-ts-autotag").setup({
				filetypes = { "html", "javascript", "jsx", "typescript", "tsx", "php" },
			})
		end,
	})

	-- Editing Enhancements
	use({
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	use({
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter", "CmdlineEnter" },
		branch = "v0.6",
		config = function()
			require("ultimate-autopair").setup({
				enabled = function()
					local ft = vim.bo.filetype
					return ft == "http" or ft == "json"
				end,
			})
		end,
	})

	-- Git Integration
	use({
		"lewis6991/gitsigns.nvim",
		config = function()
			require("config.gitsigns")
		end,
	})

	-- UI and Appearance
	use({
		"nvim-lualine/lualine.nvim",
		event = "BufEnter",
		config = function()
			require("config.lualine")
		end,
		requires = { "nvim-web-devicons" },
	})

	-- Colorschemes
	use({
		"zenbones-theme/zenbones.nvim",
		requires = "rktjmp/lush.nvim",
		config = function()
			require("config.colorScheme")
		end,
	})

	use({
		"vague2k/vague.nvim",
		config = function()
			require("config.vague")
		end,
	})

	-- Navigation and File Management
	use({
		"nvim-tree/nvim-tree.lua",
		after = "nvim-web-devicons",
		requires = "nvim-tree/nvim-web-devicons",
		config = function()
			require("config.nvimtree")
		end,
	})

	use({
		"ggandor/leap.nvim",
		config = function()
			require("config.leap")
		end,
	})

	use({
		"andrewferrier/debugprint.nvim",
		config = function()
			require("config.debugPrint")
		end,
	})

	-- Terminal
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = function()
			require("config.toggleterm")
		end,
	})

	-- Command Line
	use("roxma/nvim-yarp")
	use("roxma/vim-hug-neovim-rpc")
	use({
		"gelguy/wilder.nvim",
		config = function()
			require("config.wilder") -- or wherever your config is
		end,
		requires = { "romgrk/fzy-lua-native" }, -- for Lua filters
	})

	-- Cursor Enhancements
	use({
		"sphamba/smear-cursor.nvim",
		config = function()
			require("config.smearCursor")
		end,
	})

	-- Formatters
	use({
		"stevearc/conform.nvim",
		config = function()
			require("config.conform")
		end,
	})

	use({
		"mistweaverco/kulala.nvim",
		config = function()
			require("config.kulala")
		end,
	})

	-- comment
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})

	-- git
	use({
		"sindrets/diffview.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("config.diffView")
		end,
	})

	-- syntax
	use({
		"kylechui/nvim-surround",
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({})
		end,
	})

	--fuzzy finder

	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		requires = { { "nvim-lua/plenary.nvim" } },
		config = function()
			require("config.telescope")
		end,
	})

	-- ai suggestion
	use("MunifTanjim/nui.nvim")
	use("MeanderingProgrammer/render-markdown.nvim")

	-- Optional dependencies
	use("HakonHarnes/img-clip.nvim")
	use("zbirenbaum/copilot.lua")
	use("stevearc/dressing.nvim") -- for enhanced input UI
	use("folke/snacks.nvim") -- for modern input UI
end)
