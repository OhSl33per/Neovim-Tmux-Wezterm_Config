return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "cssls",     -- CSS
          "eslint",    -- JavaScript / TypeScript linting
          "html",      -- HTML
          "jsonls",    -- JSON
          "omnisharp", -- C#
          "pyright",   -- Python
          "lua_ls",    -- Lua
        },
        automatic_installation = true,
      })
    end,
  },
}
