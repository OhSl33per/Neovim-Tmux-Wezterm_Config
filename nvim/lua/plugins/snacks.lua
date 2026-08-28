return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  dependencies = {
    "nvim-mini/mini.icons",
    "nvim-tree/nvim-web-devicons",
  },
  ---@module 'snacks'
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    scope = { enabled = true },
    dim = {
      enabled = true,
    },
    zen = {
      enabled = true,
      -- center = true,                -- center the buffer in the zen window
      -- toggles = {                   -- snacks.toggle states to set on open (restored on close)
      --   dim = true,                 -- dim inactive code
      --   git_signs = false,          -- hide git signs
      --   mini_diff_signs = false,    -- hide mini.diff signs
      --   -- diagnostics = false,     -- hide diagnostics
      --   -- inlay_hints = false,     -- hide inlay hints
      -- },
      -- show = {
      --   statusline = false,         -- show global statusline (requires laststatus=3)
      --   tabline = false,            -- show tabline in zen
      -- },
      -- on_open = function(win) end,  -- callback when zen window opens
      -- on_close = function(win) end, -- callback when zen window closes
      win = {
        width = 0, -- 0 = full width (zoom), number = fixed cols e.g. 120
      },
      dim = {
        enabled = true,
      },
    },
    toggle = {
      enabled = true,
    },
    notifier = {
      enabled = true,
    },
  },
  config = function(_, opts)
    require("snacks").setup(opts)

    -- snacks.dim defaults SnacksDim to DiagnosticUnnecessary, which in
    -- github_dark_default is already a medium gray indistinguishable from
    -- dimmed text. Force it darker so the active scope is clearly visible.
    local function set_dim_hl()
      vim.api.nvim_set_hl(0, "SnacksDim", { fg = "#363636" })
      vim.api.nvim_set_hl(0, "MarkSignHL", { fg = "#ff8400", bold = true })
      vim.api.nvim_set_hl(0, "MarksignNumHL", { fg = "#ff8400", bold = true })
    end
    set_dim_hl()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_dim_hl })
  end,
  keys = {
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Snacks Zen Mode",
    },
    -- {
    --   "<leader>D",
    --   function()
    --     Snacks.dim()
    --   end,
    --   desc = "Snacks Dim [out of scope]"
    -- }
    -- {
    --   "<leader>fm",
    --   function()
    --     Snacks.picker.marks()
    --   end,
    --   desc = "Snacks Marks"
    -- },
  },
}
