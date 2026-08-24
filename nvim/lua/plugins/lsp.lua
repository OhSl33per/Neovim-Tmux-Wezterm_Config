return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    -- Keybinds that activate when any LSP attaches to a buffer
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local function map(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = event.buf, desc = desc })
        end

        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.type_definition, "Go to type definition")
        -- map("gr", vim.lsp.buf.references, "Find references")
        map("gI", vim.lsp.buf.implementation, "Go to implementation")
        map("gh", vim.lsp.buf.hover, "Go Hover documentation")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>cd", vim.diagnostic.open_float, "Show diagnostic")
        map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("]d", vim.diagnostic.goto_next, "Next diagnostic")
      end,
    })

    -- New 0.11+ API: vim.lsp.config instead of lspconfig.server.setup()
    vim.lsp.config("cssls", { capabilities = capabilities })
    vim.lsp.config("eslint", {
      capabilities = capabilities,
      settings = {
        -- Ensure onIgnoredFiles is explicitly set so ESLint doesn't silently discard buffers
        onIgnoredFiles = "off",
        run = "onType",
        format = false,
      },
      -- nvim-lspconfig's default root_dir resolves via package-lock.json/yarn.lock,
      -- which stops at client/'s own lockfile and never reaches the repo-root
      -- eslint.config.mts. Override it to walk up for the flat config (or .git)
      -- directly, so client/ and server/ both resolve to the true repo root.
      root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, {
          "eslint.config.js",
          "eslint.config.mjs",
          "eslint.config.cjs",
          "eslint.config.ts",
          "eslint.config.mts",
          "eslint.config.cts",
          ".git",
        })
        on_dir(root)
      end,
    })
    vim.lsp.config("html", { capabilities = capabilities })
    vim.lsp.config("jsonls", { capabilities = capabilities })
    vim.lsp.config("pyright", { capabilities = capabilities })
    vim.lsp.config("omnisharp", { capabilities = capabilities })
    vim.lsp.config("angularls", { capabilities = capabilities })
    vim.lsp.config("biome", {
      capabilities = capabilities,
      root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, { "biome.json", "biome.jsonc", ".git" })
        on_dir(root)
      end,
    })
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            -- Prevent lua_ls flagging 'vim' as an undefined global
            globals = { "vim" },
          },
        },
      },
    })

    -- Enable all configured servers
    vim.lsp.enable({ "cssls", "eslint", "html", "jsonls", "pyright", "omnisharp", "angularls", "biome", "lua_ls" })
  end,
}
