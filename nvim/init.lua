vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Auto-recover swap files silently and delete the swap after recovery
vim.opt.swapfile = false

vim.opt.number = true
-- vim.opt.relativenumber = true

local sysname = vim.uv.os_uname().sysname

local is_mac = sysname == "Darwin"
local is_linux = sysname == "Linux"
local is_win = sysname == "Windows_NT"

local is_wsl = vim.fn.has("wsl") == 1
	or (is_linux and vim.fn.readfile("/proc/version")[1]:lower():find("microsoft") ~= nil)
print("Source System:", sysname, " -- ", "Is WSL:", is_wsl)
local v = vim.version()
print(string.format("Neovim %d.%d.%d", v.major, v.minor, v.patch))

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
	spec = {

		-- Colorscheme
		--    {
		--      "EdenEast/nightfox.nvim",
		--      lazy = false,
		--      priority = 1000,
		--      config = function()
		--        vim.cmd("colorscheme carbonfox")
		--      end,
		--    },
		--
		-- { "folke/tokyonight.nvim", lazy = false, priority = 1000 },   -- very popular, great contrast

		-- {
		-- 	"scottmckendry/cyberdream.nvim",
		-- 	lazy = false,
		-- 	priority = 1000,
		-- 	config = function()
		-- 		require("cyberdream").setup({
		-- 			colors = {
		-- 				bg = "#000000",
		-- 			},
		-- 		})
		-- 	end,
		-- },
		{
			"projekt0n/github-nvim-theme",
			lazy = false,
			priority = 1000,
			config = function()
				require("github-theme").setup({
					options = {
						transparent = true,
					},
				})
			end,
		},

		-- Telescope
		{
			"nvim-telescope/telescope.nvim",
			version = "*",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			},
			config = function()
				local actions = require("telescope.actions")
				require("telescope").setup({
					defaults = {
						mappings = {
							i = {
								-- cycle through prompt history with C-n/C-p
								["<C-n>"] = actions.cycle_history_next,
								["<C-p>"] = actions.cycle_history_prev,
								-- move selection with C-j/C-k instead
								["<C-j>"] = actions.move_selection_next,
								["<C-k>"] = actions.move_selection_previous,
							},
						},
					},
				})
			end,
			keys = {
				{
					"<C-p>",
					function()
						require("telescope.builtin").find_files()
					end,
					desc = "Find files",
				},
				{
					"<leader>tl",
					function()
						require("telescope.builtin").live_grep()
					end,
					desc = "Live grep",
				},
				{
					"<leader>gs",
					function()
						require("telescope.builtin").git_status()
					end,
					desc = "Git status (changed files)",
				},
				{
					"<leader>tr",
					function()
						require("telescope.builtin").resume()
					end,
					desc = "Resume last search",
				},
			},
		},

		-- Wilder: fuzzy autocomplete popup for the cmdline (:) and search (/, ?)
		{
			"gelguy/wilder.nvim",
			event = "CmdlineEnter",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				local wilder = require("wilder")
				wilder.setup({ modes = { ":", "/", "?" } })

				wilder.set_option("pipeline", {
					wilder.branch(
						wilder.cmdline_pipeline({
							fuzzy = 1, -- fuzzy match commands, filenames, etc.
							language = "vim", -- avoid requiring python3/pynvim remote plugin support
						}),
						wilder.vim_search_pipeline() -- fuzzy match against buffer lines for / and ?
					),
				})

				wilder.set_option(
					"renderer",
					wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
						highlighter = wilder.basic_highlighter(),
						left = { " ", wilder.popupmenu_devicons() },
						right = { " ", wilder.popupmenu_scrollbar() },
						border = "rounded",
					}))
				)
			end,
		},

		-- Treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			tag = "v0.9.3",
			build = ":TSUpdate",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"lua",
						"vim",
						"vimdoc",
						"javascript",
						"typescript",
						"tsx",
						"json",
						"jsonc",
						"html",
						"css",
						"python",
						"c_sharp",
						"markdown",
						"markdown_inline",
					},
					auto_install = false,
					highlight = { enable = true },
					indent = { enable = true },
					disable = { "lua" },
				})
			end,
		},

		-- Word highlight under cursor
		{
			"RRethy/vim-illuminate",
			event = "VimEnter",
		},

		-- Mason: installs language servers
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end,
		},

		-- Mason-lspconfig: bridges mason and lspconfig
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = { "williamboman/mason.nvim" },
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = {
						"cssls", -- CSS
						"eslint", -- JavaScript / TypeScript linting
						"html", -- HTML
						"jsonls", -- JSON
						"omnisharp", -- C#
						"pyright", -- Python
						"lua_ls", -- Lua
					},
					automatic_installation = true,
				})
			end,
		},

		-- nvim-lspconfig: provides server configs, but we use vim.lsp.config (0.11+ API)
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"williamboman/mason-lspconfig.nvim",
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				local capabilities = require("cmp_nvim_lsp").default_capabilities()

				-- Keybinds that activate when any LSP attaches to a buffer
				vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(event)
						local function map(lhs, rhs, desc)
							vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
						end

						map("gd", vim.lsp.buf.definition, "Go to definition")
						map("gD", vim.lsp.buf.type_definition, "Go to type definition")
						-- map("gr", vim.lsp.buf.references, "Find references")
						map("gI", vim.lsp.buf.implementation, "Go to implementation")
						map("gh", vim.lsp.buf.hover, "Go Hover documentation")
						map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
						map("<leader>ca", vim.lsp.buf.code_action, "Code action")
						map("<leader>cd", vim.diagnostic.open_float, "Show diagnostic")
						map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
						map("]d", vim.diagnostic.goto_next, "Next diagnostic")
					end,
				})

				-- New 0.11+ API: vim.lsp.config instead of lspconfig.server.setup()
				vim.lsp.config("cssls", { capabilities = capabilities })
				vim.lsp.config("eslint", { capabilities = capabilities })
				vim.lsp.config("html", { capabilities = capabilities })
				vim.lsp.config("jsonls", { capabilities = capabilities })
				vim.lsp.config("pyright", { capabilities = capabilities })
				vim.lsp.config("omnisharp", { capabilities = capabilities })
				vim.lsp.config("lua_ls", {
					capabilities = capabilities,
					settings = {
						Lua = {
							diagnostics = {
								-- Prevent lua_ls flagging 'vim' as an undefined global
								globals = { "vim" },
							},
						},
					},
				})

				-- Enable all configured servers
				vim.lsp.enable({ "cssls", "eslint", "html", "jsonls", "pyright", "omnisharp", "lua_ls" })
			end,
		},

		-- Autocompletion
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
			config = function()
				local cmp = require("cmp")
				local luasnip = require("luasnip")

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					mapping = cmp.mapping.preset.insert({
						["<C-Space>"] = cmp.mapping.complete(), -- trigger manually
						["<CR>"] = cmp.mapping.confirm({ select = true }), -- confirm with Enter
						["<Tab>"] = cmp.mapping(function(fallback) -- cycle forward
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function(fallback) -- cycle backward
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "buffer" },
						{ name = "path" },
					}),
				})
			end,
		},
		{
			"ray-x/lsp_signature.nvim",
			event = "InsertEnter",
			opts = {
				hint_enable = false,
				handler_opts = { border = "rounded" },
			},
		},
		{
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- file icons
				"MunifTanjim/nui.nvim",
			},
			config = function()
				require("neo-tree").setup({
					filesystem = {
						filtered_items = {
							hide_dotfiles = false, -- show hidden files like .env, .gitignore
							hide_gitignored = false,
						},
						follow_current_file = {
							enabled = true, -- Focuses the active file in the tree automatically
							leave_dirs_open = false, -- Closes collapsed directories when changing files (optional)
						},
						use_libuv_file_watcher = true, -- Automatically updates tree when files change on disk
					},
					reveal = true,
				})
			end,
			keys = {
				{ "<leader>e", ":Neotree filesystem reveal toggle<CR>", desc = "Toggle file explorer" },
			},
		},
		{
			"mbbill/undotree",
			cmd = "UndotreeToggle", -- Lazy-loads the plugin only when you run the command
			keys = {
				{ "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
			},
			config = function()
				-- Enable persistent undo on disk
				vim.opt.undofile = true
			end,
		},
		{
			"github/copilot.vim",
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
				triggers = {
					{ "<auto>", mode = "nixsotc" },
					{ "<C>", mode = { "n", "v" } },
				},
			},
			keys = {
				{
					"<leader>?",
					function()
						require("which-key").show({ global = false })
					end,
					desc = "Buffer Local Keymaps (which-key)",
				},
				{
					"<leader>/",
					function()
						require("which-key").show({ global = true })
					end,
					desc = "Buffer ALL Keymaps (which-key)",
				},
			},
		},
		{
			"stevearc/conform.nvim",
			opts = {
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettierd", "prettier", stop_after_first = true },
					typescript = { "prettierd", "prettier", stop_after_first = true },
					typescriptreact = { "prettierd", "prettier", stop_after_first = true },
					javascriptreact = { "prettierd", "prettier", stop_after_first = true },
					json = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			},
			keys = {
				{ "<leader>cf", vim.lsp.buf.format, desc = "Format document" },
			},
		},
		{
			"mrjones2014/smart-splits.nvim",
			lazy = false,
			keys = {
				-- resizing splits
				-- these keymaps will also accept a range,
				-- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
				{
					"<A-h>",
					function()
						require("smart-splits").resize_left()
					end,
					desc = "Resize split left",
				},
				{
					"<A-j>",
					function()
						require("smart-splits").resize_down()
					end,
					desc = "Resize split down",
				},
				{
					"<A-k>",
					function()
						require("smart-splits").resize_up()
					end,
					desc = "Resize split up",
				},
				{
					"<A-l>",
					function()
						require("smart-splits").resize_right()
					end,
					desc = "Resize split right",
				},
				-- moving between splits
				{
					"<C-h>",
					function()
						require("smart-splits").move_cursor_left()
					end,
					desc = "Move to split left",
				},
				{
					"<C-j>",
					function()
						require("smart-splits").move_cursor_down()
					end,
					desc = "Move to split down",
				},
				{
					"<C-k>",
					function()
						require("smart-splits").move_cursor_up()
					end,
					desc = "Move to split up",
				},
				{
					"<C-l>",
					function()
						require("smart-splits").move_cursor_right()
					end,
					desc = "Move to split right",
				},
				{
					"<C-\\>",
					function()
						require("smart-splits").move_cursor_previous()
					end,
					desc = "Move to previous split",
				},
				-- swapping buffers between windows
				{
					"<leader><leader>h",
					function()
						require("smart-splits").swap_buf_left()
					end,
					desc = "Swap buffer left",
				},
				{
					"<leader><leader>j",
					function()
						require("smart-splits").swap_buf_down()
					end,
					desc = "Swap buffer down",
				},
				{
					"<leader><leader>k",
					function()
						require("smart-splits").swap_buf_up()
					end,
					desc = "Swap buffer up",
				},
				{
					"<leader><leader>l",
					function()
						require("smart-splits").swap_buf_right()
					end,
					desc = "Swap buffer right",
				},
			},
		},
		{
			"kevinhwang91/nvim-ufo",
			dependencies = "kevinhwang91/promise-async",
			config = function()
				require("ufo").setup()
			end,
			keys = {
				{
					"zR",
					function()
						require("ufo").openAllFolds()
					end,
					desc = "Open all folds",
				},
				{
					"zM",
					function()
						require("ufo").closeAllFolds()
					end,
					desc = "Close all folds",
				},
			},
		},
		{
			"luukvbaal/statuscol.nvim",
			config = function()
				local builtin = require("statuscol.builtin")
				require("statuscol").setup({
					segments = {
						{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
						{ text = { "%s" }, click = "v:lua.ScSa" },
						{
							text = { builtin.lnumfunc, " " },
							condition = { true, builtin.not_empty },
							click = "v:lua.ScLa",
						},
					},
				})
			end,
		},
		{
			"lewis6991/gitsigns.nvim",
			event = { "BufReadPre", "BufNewFile" },
			opts = {
				signs = {
					add = { text = "█" },
					change = { text = "█" },
					delete = { text = "█" },
					topdelete = { text = "█" },
					changedelete = { text = "█" },
					untracked = { text = "█" },
				},
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 500,
					virt_text_pos = "eol",
					ignore_whitespace = true,
				},
			},
			keys = {
				{
					"<leader>gj",
					function()
						require("gitsigns").next_hunk()
					end,
					desc = "Next Git hunk",
				},
				{
					"<leader>gk",
					function()
						require("gitsigns").prev_hunk()
					end,
					desc = "Previous Git hunk",
				},
				{
					"<leader>gp",
					function()
						require("gitsigns").preview_hunk()
					end,
					desc = "Preview Git hunk",
				},
			},
		},
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = function()
				require("nvim-autopairs").setup()
			end,
		},
		{
			"folke/trouble.nvim",
			opts = {}, -- for default options, refer to the configuration section for custom setup.
			cmd = "Trouble",
			keys = {
				{
					"<leader>xx",
					"<cmd>Trouble diagnostics toggle<cr>",
					desc = "Diagnostics (Trouble)",
				},
				{
					"<leader>xX",
					"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
					desc = "Buffer Diagnostics (Trouble)",
				},
				{
					"<leader>cs",
					"<cmd>Trouble symbols toggle focus=false<cr>",
					desc = "Symbols (Trouble)",
				},
				{
					"<leader>cl",
					"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
					desc = "LSP Definitions / references / ... (Trouble)",
				},
				{
					"<leader>xL",
					"<cmd>Trouble loclist toggle<cr>",
					desc = "Location List (Trouble)",
				},
				{
					"<leader>xQ",
					"<cmd>Trouble qflist toggle<cr>",
					desc = "Quickfix List (Trouble)",
				},
			},
		},
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },

			lazy = false,

			config = function(_, opts)
				local api = require("typescript-tools.api")

				opts.capabilities = require("cmp_nvim_lsp").default_capabilities()
				opts.handlers = {
					["textDocument/publishDiagnostics"] = api.filter_diagnostics({
						80001, -- Ignore this might be converted to a ES export
					}),
				}
				require("typescript-tools").setup(opts)
			end,
			opts = {
				settings = {
					expose_as_code_action = "all",
					complete_function_calls = false,
					jsx_close_tag = {
						enable = true,
						filetypes = { "javascriptreact", "typescriptreact" },
					},
					tsserver_file_preferences = {
						includeInlayParameterNameHints = "all",
						includeInlayEnumMemberValueHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayVariableTypeHints = true,
					},
				},
				on_attach = function(client, bufNr)
					-- Add toggle for inlay hints
					-- vim.keymap.set(
					-- "n",
					-- "<leader>th",
					-- function()
					-- vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufNr }), { bufnr = bufNr })
					-- end,
					-- { desc = "Toggle Inlay Hints", silent = true, buffer = bufNr }
					-- )

					-- vim.keymap.set(
					-- 	"n",
					-- 	"K",
					-- 	vim.lsp.buf.hover,
					-- 	{ desc = "Hover documentation", silent = true, buffer = bufNr }
					-- )

					vim.keymap.set(
						{ "n", "v" },
						"<leader>io",
						":TSToolsOrganizeImports<CR>",
						{ desc = "Imports Organize", silent = true, buffer = bufNr }
					)

					vim.keymap.set(
						{ "n", "v" },
						"<leader>is",
						":TSToolsSortImports<CR>",
						{ desc = "Imports Sort", silent = true, buffer = bufNr }
					)

					vim.keymap.set({ "n", "v" }, "<leader>ir", ":TSToolsRemoveUnusedImports<CR>", {
						desc = "Imports remove unused",
						silent = true,
						buffer = bufNr,
					})

					vim.keymap.set({ "n", "v" }, "<leader>ia", ":TSToolsAddMissingImports<CR>", {
						desc = "Imports Add All missing",
						silent = true,
						buffer = bufNr,
					})

					vim.keymap.set(
						{ "n", "v" },
						"<leader>rf",
						":TSToolsRenameFile<CR>",
						{ desc = "Rename File", silent = true, buffer = bufNr }
					)
				end,
			},
		},
		{
			"sindrets/diffview.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			cmd = { "DiffviewOpen", "DiffviewFileHistory" },
			config = function()
				require("diffview").setup({
					hooks = {
						view_opened = function()
							-- Force all windows in the tab to enable diff mode and recalculate alignment
							vim.cmd("windo diffthis")
							vim.cmd("diffupdate")
						end,
						buf_win_enter = function()
							-- Recalculate whenever switching files in the file panel
							if vim.wo.diff then
								vim.cmd("diffupdate")
							end
						end,
					},
				})
			end,
			keys = {
				{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git: Open Diffview" },
				{ "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Git: Close Diffview" },
				{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git: Current File History" },
				{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Git: Repo Branch History" },
				{ "<leader>gu", "<cmd>diffupdate<cr>", desc = "Git: Force Diff Re-align" },
				{ "<leader>gr", "<cmd>DiffviewRefresh<cr>", desc = "Git: Refresh Diffview" },
			},
		},
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
			config = function()
				local harpoon = require("harpoon")
				harpoon:setup()

				-- Custom telescope picker over the harpoon list
				local function toggle_telescope(harpoon_files)
					local finders = require("telescope.finders")
					local conf = require("telescope.config").values
					local file_paths = {}
					for _, item in ipairs(harpoon_files.items) do
						table.insert(file_paths, item.value)
					end

					require("telescope.pickers")
						.new({}, {
							prompt_title = "Harpoon",
							finder = finders.new_table({
								results = file_paths,
							}),
							previewer = conf.file_previewer({}),
							sorter = conf.generic_sorter({}),
						})
						:find()
				end

				vim.keymap.set("n", "<leader>ha", function()
					harpoon:list():add()
				end, { desc = "Harpoon: Add file" })

				vim.keymap.set("n", "<leader>hd", function()
					harpoon:list():remove()
				end, { desc = "Harpoon: Remove file" })

				vim.keymap.set("n", "<leader>hc", function()
					harpoon:list():clear()
				end, { desc = "Harpoon: Clear list" })

				vim.keymap.set("n", "<leader>he", function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end, { desc = "Harpoon: Toggle quick menu" })

				vim.keymap.set("n", "<leader>hh", function()
					toggle_telescope(harpoon:list())
				end, { desc = "Harpoon: Telescope picker" })

				vim.keymap.set("n", "<leader>hp", function()
					harpoon:list():prev()
				end, { desc = "Harpoon: Prev file" })

				vim.keymap.set("n", "<leader>hn", function()
					harpoon:list():next()
				end, { desc = "Harpoon: Next file" })

				for i = 1, 4 do
					vim.keymap.set("n", "<leader>h" .. i, function()
						harpoon:list():select(i)
					end, { desc = "Harpoon: Select file " .. i })
				end
			end,
		},

		{
			"tpope/vim-fugitive",
			keys = {
				-- { "<leader>gfs", "<cmd>vert Git<cr>", desc = "Git: Source Control Panel" },
				{
					"<leader>gfs",
					function()
						-- Check if fugitive panel is currently open
						for _, win in ipairs(vim.api.nvim_list_wins()) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].filetype == "fugitive" then
								vim.api.nvim_win_close(win, false)
								return
							end
						end
						-- If not open, launch it in a 40-column vertical split
						vim.cmd("vert Git")

						-- Explicitly set the width of the newly opened panel (e.g., 40 columns)
						vim.api.nvim_win_set_width(0, 40)
					end,
					desc = "Git: Toggle Source Control Sidebar",
				},
				{ "<leader>gfp", "<cmd>Git push<cr>", desc = "Git: Push" },
				{ "<leader>gfl", "<cmd>Git pull<cr>", desc = "Git: Pull" },
			},
		},
		{
			"lewis6991/satellite.nvim",
		},
	},
	install = { colorscheme = { "carbonfox", "habamax" } },
	checker = { enabled = true },
})

vim.cmd("colorscheme github_dark_default")

vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
	fg = "#00ff1a",
	italic = true,
})

-- Trouble displays diagnostics in a list; Neovim renders them in the buffer.
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
		source = "if_many",
		spacing = 2,
	},
	signs = false,
	underline = true,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many",
	},
})

-- Diagnostic highlight colors
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#ff1500", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#ff7700", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#02cae0", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#e002d9", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#ff1500" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#ff7700" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#02cae0" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#e002d9" })

-- Optional: disable arrow keys to force hjkl habit
vim.keymap.set("n", "<Up>", "<Nop>", { desc = "Disable Up arrow" })
vim.keymap.set("n", "<Down>", "<Nop>", { desc = "Disable Down arrow" })
vim.keymap.set("n", "<Left>", "<Nop>", { desc = "Disable Left arrow" })
vim.keymap.set("n", "<Right>", "<Nop>", { desc = "Disable Right arrow" })

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
-- Paste from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.diffopt:append({
	"algorithm:histogram", -- Improves diff accuracy
	"indent-heuristic", -- Keeps code context aligned
	"vertical", -- Forces vertical splits
	"linematch:60", -- Better line-by-line alignment
})

vim.keymap.set("n", "<leader>xc", ":cclose<CR>", { desc = "Close quickfix" })

vim.keymap.set({ "n", "v" }, "<Leader>j", "J", { noremap = true, silent = true, desc = "Join Lines" })

local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "v" }, "J", "10j", { desc = "Jump down 10 lines" }, opts)
vim.keymap.set({ "n", "v" }, "K", "10k", { desc = "Jump up 10 lines" }, opts)
vim.keymap.set({ "n", "v" }, "H", "10h", { desc = "Jump left 10 chars" }, opts)
vim.keymap.set({ "n", "v" }, "L", "10l", { desc = "Jump right 10 chars" }, opts)

if is_wsl == true then
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		},
		cache_enabled = 0,
	}
end

local function load_grep_matches_to_buffer(pattern, root)
	root = root or vim.loop.cwd()
	local handle = io.popen(string.format("rg -w --files-with-matches %q %q", pattern, root))
	if not handle then
		vim.notify("Failed to run ripgrep", vim.log.levels.ERROR)
		return
	end
	local result = handle:read("*a")
	handle:close()
	local files = {}
	for file in result:gmatch("[^\r\n]+") do
		file = vim.fn.fnamemodify(vim.trim(file), ":p") -- ensure absolute path, trim whitespace
		if vim.fn.filereadable(file) == 1 then
			local bufnr = vim.fn.bufadd(file)
			vim.fn.bufload(bufnr)
			vim.bo[bufnr].buflisted = true -- Make sure buffer is listed!
			table.insert(files, file)
		end
	end
	if #files == 0 then
		vim.notify("No files found matching: " .. pattern, vim.log.levels.INFO)
		return
	end
	vim.notify(("Loaded %d files into buffer for pattern: %s"):format(#files, pattern))
end

vim.api.nvim_create_user_command("LoadGrepBuffers", function(opts)
	load_grep_matches_to_buffer(opts.args)
end, { nargs = 1, complete = "file" })

vim.keymap.set("n", "<leader>fw", function()
	local cword = vim.fn.expand("<cword>")
	load_grep_matches_to_buffer(cword)
end, { desc = "Load into buffers all files matching word under cursor" })
