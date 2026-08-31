return {
	"folke/twilight.nvim",
	opts = {
		dimming = {
			alpha = 0.25,
			-- Tells Twilight to use black for the dimming math,
			-- bridging the gap between Neovim's transparency and Tmux's black background
		},
		term_bg = "#000000",
		context = 5,
	},
	keys = {
		{ "<leader>z", ":Twilight<CR>", mode = { "n", "v" }, desc = "DIM Mode" },
	},
}
