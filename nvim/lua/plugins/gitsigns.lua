return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "█" },
      change       = { text = "█" },
      delete       = { text = "█" },
      topdelete    = { text = "█" },
      changedelete = { text = "█" },
      untracked    = { text = "█" },
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
      function() require("gitsigns").next_hunk() end,
      desc = "Next Git hunk",
    },
    {
      "<leader>gk",
      function() require("gitsigns").prev_hunk() end,
      desc = "Previous Git hunk",
    },
    {
      "<leader>gp",
      function() require("gitsigns").preview_hunk() end,
      desc = "Preview Git hunk",
    },
  },
}
