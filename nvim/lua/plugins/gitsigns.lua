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
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      -- visual mode
      map('v', '<leader>ggs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'git [s]tage hunk' })
      map('v', '<leader>ggr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'git [r]eset hunk' })
      -- normal mode
      map('n', '<leader>ggl', gitsigns.next_hunk, { desc = 'git [n]ext hunk' })
      map('n', '<leader>ggh', gitsigns.prev_hunk, { desc = 'git [p]revious hunk' })
      map('n', '<leader>ggs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
      map('n', '<leader>ggr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
      map('n', '<leader>ggS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
      map('n', '<leader>ggu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
      map('n', '<leader>ggR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
      map('n', '<leader>ggp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
      map('n', '<leader>ggb', gitsigns.blame_line, { desc = 'git [b]lame line' })
      map('n', '<leader>ggd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
      map('n', '<leader>ggc', function()
        gitsigns.diffthis '@'
      end, { desc = 'git [D]iff against last commit' })
      -- Toggles
      map('n', '<leader>ggB', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
      map('n', '<leader>ggD', gitsigns.preview_hunk_inline, { desc = '[T]oggle git show [D]eleted' })
    end,
  },
}
