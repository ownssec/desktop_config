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

	-- Mason LSP Bridge
	use({
		"williamboman/mason-lspconfig.nvim",
		after = "mason.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls", -- TypeScript/JavaScript + React
					"html",
					"cssls",
					"tailwindcss",
					"eslint",
					"intelephense", -- PHP
				},
				automatic_installation = true,
			})
		end,
	})

	-- blink.cmp v1
	use({
		"saghen/blink.cmp",
		tag = "v1.*",
		requires = { "rafamadriz/friendly-snippets" },
		config = function()
			require("blink.cmp").setup({
				keymap = { preset = "super-tab" },

				appearance = {
					nerd_font_variant = "mono",
					use_nvim_cmp_as_default = true,
				},

				completion = {
					documentation = { auto_show = false },
				},

				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},

				fuzzy = { implementation = "rust" },
			})

			-- Brighter completion menu colors
			vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#1e1e2e" }) -- background
			vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#45475a", fg = "#cdd6f4" }) -- selected item
			vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = "#9c9992" }) -- main text
			vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#9c9992", bold = true }) -- matched letters
			vim.api.nvim_set_hl(0, "BlinkCmpKind", { fg = "#977C71" }) -- icons (functions, variables, etc.)
		end,
	})

	-- LSP Config (nvim-lspconfig)
	use({
		"neovim/nvim-lspconfig",
		after = { "blink.cmp", "mason-lspconfig.nvim" },
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Setup servers with capabilities
			local servers = { "lua_ls", "ts_ls", "html", "cssls", "tailwindcss", "eslint", "intelephense" }

			for _, server in ipairs(servers) do
				require("lspconfig")[server].setup({
					capabilities = capabilities,
				})
			end

			-- Custom settings for lua_ls
			require("lspconfig").lua_ls.setup({
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
					},
				},
			})

			-- TailwindCSS custom config (for React/TSX)
			require("lspconfig").tailwindcss.setup({
				capabilities = capabilities,
				filetypes = {
					"html",
					"css",
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"tsx",
				},
			})
		end,
	})

	-- Syntax and Language Support
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("config.treesitter")
		end,
	})

	use({
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascriptreact", "typescriptreact", "javascript", "typescript", "tsx", "php" },
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
			require("nvim-autopairs").setup({
				check_ts = true,
				enable_check_bracket_line = true,
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
		"https://codeberg.org/andyg/leap.nvim",
		config = function()
			local ok, leap = pcall(require, "leap")
			if not ok then
				return
			end

			-- IMPORTANT:
			-- Do NOT use this removed option:
			-- leap.opts.highlight_unlabeled_phase_one_targets = true
			--
			-- Do NOT use:
			-- leap.opts.safe_labels = {}

			-- Replacement for the removed option
			leap.opts.on_beacons = function(targets)
				for _, t in ipairs(targets) do
					if not t.label and not t.beacon and t.chars and t.is_previewable ~= false then
						t.beacon = {
							0,
							{
								virt_text = {
									{ table.concat(t.chars), "LeapMatch" },
								},
							},
						}
					end
				end
			end

			-- Optional highlight
			vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })

			-- Keymaps
			vim.keymap.set({ "n", "x", "o" }, "f", "<Plug>(leap)", { silent = true })

			vim.keymap.set({ "n", "x", "o" }, "F", function()
				leap.leap({
					backward = true,
					target_windows = { vim.api.nvim_get_current_win() },
				})
			end, { silent = true })
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
	-- use({
	-- 	"sphamba/smear-cursor.nvim",
	-- 	config = function()
	-- 		require("config.smearCursor")
	-- 	end,
	-- })

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
			vim.opt_local.foldenable = false
			vim.opt_local.foldmethod = "manual"
			vim.opt_local.foldlevel = 99
		end,
	})

	-- comment
	use("JoosepAlviste/nvim-ts-context-commentstring")

	use({
		"numToStr/Comment.nvim",
		config = function()
			vim.defer_fn(function()
				require("ts_context_commentstring").setup({
					enable_autocmd = false,
				})

				require("Comment").setup({
					padding = true,
					sticky = true,

					toggler = { line = "gcc", block = "gbc" },
					opleader = { line = "gc", block = "gb" },

					pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
				})
			end, 100)
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
		branch = "master",
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

	-- git

	use({
		"tpope/vim-fugitive",
	})

	use({
		"debsishu/floatodo.nvim",
		config = function()
			local floatodo = require("floatodo")

			floatodo.setup({
				path = "~/todo.md",
				width_percent = 0.8,
				height_percent = 0.8,
				insert_on_open = true,
			})

			-- toggle key
			vim.keymap.set("n", "[td", function()
				floatodo.floatodo_toggle()

				-- apply buffer-local mappings when opened
				vim.schedule(function()
					local buf = vim.api.nvim_get_current_buf()

					-- disable ESC closing (normal mode only)
					vim.keymap.set("n", "<Esc>", "<Nop>", { buffer = buf })

					-- use 'q' to close
					vim.keymap.set("n", "q", function()
						floatodo.floatodo_toggle()
					end, { buffer = buf, silent = true })
				end)
			end, { desc = "Toggle Floating TODO" })
		end,
	})

	-- SQL / Database plugins
	use({ "tpope/vim-dadbod" })

	use({
		"kristijanhusak/vim-dadbod-ui",
		requires = { "tpope/vim-dadbod" },
		config = function()
			-- Optional nice settings
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_win_position = "left"
			vim.g.db_ui_winwidth = 40
			vim.g.db_ui_save_location = "~/queries"
			vim.g.db_ui_show_help = 0

			vim.g.dbs = {
				dev = "mysql://root:admin@localhost:3306/schoolDB",
			}
		end,
	})

	-- Optional: Autocompletion for SQL
	use({
		"kristijanhusak/vim-dadbod-completion",
		requires = { "tpope/vim-dadbod" },
		ft = { "sql", "mysql", "plsql" },
	})
end)
