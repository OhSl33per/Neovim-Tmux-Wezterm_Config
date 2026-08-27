return {
  "folke/snacks.nvim",
  dependencies = {
    "nvim-mini/mini.icons",
    "nvim-tree/nvim-web-devicons"
  },
  lazy = false,
  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    -- config here
    bigfile = { enabled = true },
    indent = { enabled = true }
  }
}
