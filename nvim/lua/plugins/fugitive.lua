return {
  "tpope/vim-fugitive",
  keys = {
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
}
