return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "saghen/blink.cmp",
    -- Add this dependency to provide the Neovim API signatures
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          -- Load luvit types when the `vim.uv` word is found
          { path = "${3rd}/luvit/library", words = { "vim%.uv" } },
        },
      },
    },
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

    local eslint_base_on_attach = vim.lsp.config.eslint.on_attach
    vim.lsp.config("eslint", {
      capabilities = capabilities,
      settings = {
        onIgnoredFiles = "off",
        run = "onType",
        format = false,
      },
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
      on_attach = function(client, bufnr)
        if eslint_base_on_attach then
          eslint_base_on_attach(client, bufnr)
        end
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "LspEslintFixAll",
        })
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
        local root = vim.fs.root(bufnr, { "biome.json", "biome.jsonc" })
        if root then
          on_dir(root)
        end
      end,
    })

    -- Updated lua_ls configuration
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            -- Kept for safety, though lazydev handles this automatically
            globals = { "vim" },
          },
          workspace = {
            -- Prevents "Do you want to configure your work environment?" popups
            checkThirdParty = false,
          },
        },
      },
    })

    -- Enable all configured servers
    vim.lsp.enable({ "cssls", "eslint", "html", "jsonls", "pyright", "omnisharp", "angularls", "biome", "lua_ls" })
  end,
}
