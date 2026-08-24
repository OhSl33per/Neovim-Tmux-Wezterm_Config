return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = {
    -- resizing splits
    { "<A-Left>",  function() require("smart-splits").resize_left() end,  desc = "Resize split left" },
    { "<A-Down>",  function() require("smart-splits").resize_down() end,  desc = "Resize split down" },
    { "<A-Up>",    function() require("smart-splits").resize_up() end,    desc = "Resize split up" },
    { "<A-Right>", function() require("smart-splits").resize_right() end, desc = "Resize split right" },
    -- moving between splits
    { "<C-h>", function() require("smart-splits").move_cursor_left() end,  desc = "Move to split left" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end,  desc = "Move to split down" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end,    desc = "Move to split up" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move to split right" },
  },
}
