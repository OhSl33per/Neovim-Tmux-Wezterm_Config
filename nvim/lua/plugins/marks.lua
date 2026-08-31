-- return {
--   "chentoast/marks.nvim",
--   event = "BufReadPre",
--   opts = {
--     default_mappings = true, -- mx, dmx, m, etc.
--     signs = true,            -- show mark letter in gutter
--     mappings = {},
--   },
-- }
--



return {
  "chentoast/marks.nvim",
  event = "BufReadPre",
  config = function()
    local marks = require("marks")
    marks.setup({
      default_mappings = true,
      builtin_marks = {},
      cyclic = true,
      force_write_shada = false,
      refresh_interval = 250,
      sign_priority = {
        lower = 10,
        upper = 15,
        builtin = 8,
        bookmark = 20,
      },
      excluded_filetypes = {},
      excluded_buftypes = {},
      bookmark_0 = {
        sign = "⚑",
        virt_text = "",
        annotate = false,
      },
      -- bookmark_1 = { sign = "♥", virt_text = "important" },
      -- ... up to bookmark_9
      mappings = {
        annotate = "<leader>ma",
        delete = "<leader>mdc",
        delete_line = "<leader>mdl",
        delete_buf = "<leader>mdb",
        delete_bookmark = "<leader>mdB",
        preview = "<leader>mp",
      },
    })

    -- UFO modifies extmarks after a bookmark is set, causing annotate to
    -- fail with "invalid line number" if called immediately. Defer it so
    -- UFO's extmark updates settle first.
    vim.keymap.set("n", "m0", function()
      marks.set_bookmark0()
      vim.defer_fn(function()
        marks.annotate()
      end, 100)
    end, { desc = "Set bookmark 0 with annotation" })
  end,
}
