return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = {
		"nvim-mini/mini.icons",
		"nvim-tree/nvim-web-devicons",
	},
	---@module 'snacks'
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		scope = { enabled = true },
		dim = {
			enabled = true,
		},
		zen = {
			enabled = true,
			win = {
				width = 0,
			},
			-- Pass dim configuration directly to Zen mode's window options:
			dim = {
				enabled = true,
			},
			styles = {
				zen = {
					-- We force Neovim's NormalFloat / Normal highlight groups to a
					-- dark solid base so the dim module's RGB math has an actual color to blend into:
					wo = {
						winblend = 0,
					},
					on_open = function(win)
						-- If you want inactive text completely pitch black:
						-- Set the dim namespace foreground directly on Normal dimming
						local ns = vim.api.nvim_create_namespace("snacks_dim")
						vim.api.nvim_set_hl(ns, "Normal", { fg = "#1a1a1a" })
					end,
				},
			},
		},
	},
	keys = {
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Snacks Zen Mode",
		},
	},
}
