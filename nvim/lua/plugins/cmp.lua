return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },
  opts = {
    snippets = { preset = "luasnip" },
    keymap = {
      preset = "none",
      ["<C-Space>"] = { "show", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-e>"] = { "cancel", "fallback" },
    },
    sources = {
      default = { "lsp", "snippets", "buffer", "path" },
    },
    completion = {
      documentation = { auto_show = true },
    },
  },
}
