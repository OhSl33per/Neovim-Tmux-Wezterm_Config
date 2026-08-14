return {
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
    { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Git: Open Diffview" },
    { "<leader>gc", "<cmd>DiffviewClose<cr>",         desc = "Git: Close Diffview" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git: Current File History" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",   desc = "Git: Repo Branch History" },
    { "<leader>gu", "<cmd>diffupdate<cr>",            desc = "Git: Force Diff Re-align" },
    { "<leader>gr", "<cmd>DiffviewRefresh<cr>",       desc = "Git: Refresh Diffview" },
  },
}
