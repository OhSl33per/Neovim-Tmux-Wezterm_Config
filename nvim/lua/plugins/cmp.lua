return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
		"folke/lazydev.nvim",
	},
	opts = {
		snippets = { preset = "luasnip" },
		keymap = {
			preset = "none",
			["<C-Space>"] = { "show", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			["<C-e>"] = { "cancel", "fallback" },
		},

		-- NEW: Enable command-line completion
		cmdline = {
			enabled = true,
			keymap = nil, -- Inherits your global keymap above so <Tab> and <CR> work normally
			sources = function()
				local type = vim.fn.getcmdtype()
				-- Search forward and backward uses buffer words
				if type == "/" or type == "?" then
					return { "buffer" }
				end
				-- Command mode uses native cmdline commands
				if type == ":" then
					return { "cmdline" }
				end
				return {}
			end,
		},

		sources = {
			default = { "lazydev", "lsp", "snippets", "buffer", "path" },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},
		},
		completion = {
			documentation = { auto_show = true },
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
			},
		},
	},
}
