return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = { char = "│" },
    scope = {
      enabled = true,        -- highlights the current scope
      show_start = false,
      show_end = false,
    },
    exclude = {
      filetypes = { "neo-tree", "help", "dashboard" },
    },
  },
}
