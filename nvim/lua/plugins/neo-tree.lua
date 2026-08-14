return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,    -- show hidden files like .env, .gitignore
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,           -- Focuses the active file in the tree automatically
          leave_dirs_open = false,  -- Closes collapsed directories when changing files (optional)
        },
        use_libuv_file_watcher = true, -- Automatically updates tree when files change on disk
      },
      reveal = true,
    })
  end,
  keys = {
    { "<leader>e", ":Neotree filesystem reveal toggle<CR>", desc = "Toggle file explorer" },
  },
}
