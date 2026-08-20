return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-live-grep-args.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            -- cycle through prompt history with C-n/C-p
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            -- move selection with C-j/C-k instead
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = false,                  -- Enable fuzzy searching
          override_generic_sorter = true, -- Override the generic sorter
          override_file_sorter = true,    -- Override the file sorter
          case_mode = "smart_case",       -- "smart_case" | "ignore_case" | "respect_case"
        },
      },
      pickers = {
        buffers = {
          mappings = {
            i = {
              -- Delete the selected buffer in Insert mode with Ctrl+d
              ["<C-d>"] = actions.delete_buffer,
            },
          },
        },
      },
    })

    -- Load extensions
    telescope.load_extension("fzf")
    telescope.load_extension("live_grep_args")
  end,
  keys = {
    {
      "<C-p>",
      function()
        require("telescope.builtin").find_files()
      end,
      desc = "Find files",
    },
    {
      "<leader>tl",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      desc = "Live grep (with args)",
    },
    {
      "<leader>gs",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "Git status (changed files)",
    },
    {
      "<leader>tr",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume last search",
    },
    {
      "<leader>tc",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find({
          -- sorting_strategy = "ascending",
          tiebreak = function(a, b, _)
            return a.lnum < b.lnum
          end,
        })
      end,
      desc = "Grep current buffer",
    },
    {
      "<leader>ts",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "Grep string under cursor",
    },
    {
      "<leader>tb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "List active buffers",
    },
    {
      "<leader>tf",
      function()
        require("telescope.builtin").treesitter({
          symbols = {
            "class",
            "function",
            "method",
          },
        })
      end,
      desc = "List Doc Symbols",
    },
    {
      "<leader>tr",
      function()
        require("telescope.builtin").lsp_references()
      end,
      desc = "Find references",
    },
    {
      "<leader>td",
      function()
        require("telescope.builtin").lsp_definitions()
      end,
      desc = "Find definitions",
    },
    {
      "<leader>tt",
      function()
        require("telescope.builtin").lsp_type_definitions()
      end,
      desc = "Find type definitions",
    },
    {
      "<leader>td",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "List diagnostics on current buffer",
    },
  },
}
