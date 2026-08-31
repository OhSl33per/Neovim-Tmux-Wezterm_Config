return {
	"folke/zen-mode.nvim",
	dependencies = { "folke/twilight.nvim" },
	opts = {
		window = {
			width = 1,
		},
		plugins = {
			twilight = {
				enabled = true,
				dimming = {
					alpha = 0.25,
					-- Tells Twilight to use black for the dimming math,
					-- bridging the gap between Neovim's transparency and Tmux's black background
				},
				term_bg = "#000000",
			},
		},
	},
	keys = {
		{ "<leader>zz", ":ZenMode<CR>", mode = { "n", "v" }, desc = "ZEN Mode" },
		{ "<leader>zd", ":Twilight<CR>", mode = { "n", "v" }, desc = "DIM Mode" },
	},
}
