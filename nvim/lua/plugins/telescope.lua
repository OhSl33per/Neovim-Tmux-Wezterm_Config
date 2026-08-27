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
      "<leader>tL",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      desc = "Live grep (with args)",
    },
    {
      "<leader>tl",
      function()
        require("telescope.builtin").live_grep({
          prompt_title = "Live grep (w/ ignore)",
          file_ignore_patterns = {
            -- Directories
            "node_modules/",
            "%.git/",
            "dist/",
            "build/",
            "coverage/",
            "%.turbo/",
            "%.next/",
            "__tests__/",
            "api-reference/",
            "drizzle",

            -- Image and media files
            "%.png$",
            "%.jpg$",
            "%.jpeg$",
            "%.gif$",
            "%.svg$",
            "%.webp$",
            "%.ico$",

            -- JS/MJS compiled outputs and sourcemaps
            "%.js$",
            "%.mjs$",
            "%.cjs$",
            "%.js%.map$",

            -- Test and spec files
            "%.test%.",
            "%.spec%.",

            -- ReadMe files
            "%.md",
          },
        })
      end,
      desc = "Live grep w/ ignore",
    },
    {
      "<leader>ta",
      function()
        require("telescope.builtin").live_grep({
          prompt_title = "Live grep (ALL)"

        })
      end,
      desc = "Live grep ALL",
    },
    {
      "<leader>tR",
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
      "<leader>tv",
      function()
        vim.cmd('normal! "zy')
        local selected = vim.fn.getreg("z")
        require("telescope.builtin").grep_string({ search = selected })
      end,
      desc = "Grep visual selection",
      mode = "v",
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
            "var",
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
      "<leader>tD",
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
    -- GIT interactions w/ telescope
    {
      "<leader>gss",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "Git status (changed files)",
    },
    {
      "<leader>gsc",
      function()
        require("telescope.builtin").git_status({
          default_text = vim.fn.expand("%:t"),
        })
      end,
      desc = "Git status (changes in current file)",
    },
  },
}
