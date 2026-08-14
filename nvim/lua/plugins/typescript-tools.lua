return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig", "hrsh7th/cmp-nvim-lsp" },
  lazy = false,
  config = function(_, opts)
    local api = require("typescript-tools.api")

    opts.capabilities = require("cmp_nvim_lsp").default_capabilities()
    opts.handlers = {
      ["textDocument/publishDiagnostics"] = api.filter_diagnostics({
        80001, -- Ignore this might be converted to a ES export
      }),
    }
    require("typescript-tools").setup(opts)
  end,
  opts = {
    settings = {
      expose_as_code_action = "all",
      complete_function_calls = false,
      jsx_close_tag = {
        enable = true,
        filetypes = { "javascriptreact", "typescriptreact" },
      },
      tsserver_file_preferences = {
        includeInlayParameterNameHints = "all",
        includeInlayEnumMemberValueHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayVariableTypeHints = true,
      },
    },
    on_attach = function(client, bufNr)
      vim.keymap.set(
        "n",
        "<leader>ih",
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufNr }), { bufnr = bufNr })
        end,
        { desc = "Toggle Inlay Hints", silent = true, buffer = bufNr }
      )

      vim.keymap.set(
        "n",
        "<leader>it",
        vim.lsp.buf.hover,
        { desc = "Hover documentation", silent = true, buffer = bufNr }
      )

      vim.keymap.set(
        { "n", "v" },
        "<leader>io",
        ":TSToolsOrganizeImports<CR>",
        { desc = "Imports Organize", silent = true, buffer = bufNr }
      )

      vim.keymap.set(
        { "n", "v" },
        "<leader>is",
        ":TSToolsSortImports<CR>",
        { desc = "Imports Sort", silent = true, buffer = bufNr }
      )

      vim.keymap.set({ "n", "v" }, "<leader>ir", ":TSToolsRemoveUnusedImports<CR>", {
        desc = "Imports remove unused",
        silent = true,
        buffer = bufNr,
      })

      vim.keymap.set({ "n", "v" }, "<leader>ia", ":TSToolsAddMissingImports<CR>", {
        desc = "Imports Add All missing",
        silent = true,
        buffer = bufNr,
      })

      vim.keymap.set(
        { "n", "v" },
        "<leader>if",
        ":TSToolsRenameFile<CR>",
        { desc = "Rename File", silent = true, buffer = bufNr }
      )
    end,
  },
}
