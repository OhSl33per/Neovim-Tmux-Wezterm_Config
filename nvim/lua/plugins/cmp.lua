return {
  "saghen/blink.cmp",
  version = "1.*",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "folke/lazydev.nvim",
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
      default = { "lazydev", "lsp", "snippets", "buffer", "path" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
      },
    },
    completion = {
      documentation = { auto_show = true },
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
      },
    },
  },
}
