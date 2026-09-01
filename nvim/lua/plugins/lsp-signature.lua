return {
  "ray-x/lsp_signature.nvim",
  event = "InsertEnter",
  opts = {
    hint_enable = false,
    handler_opts = { border = "rounded" },
  },
  config = function(_, opts)
    require("lsp_signature").setup(opts)
    -- Customize the active parameter highlight
    vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", {
      fg = "#ff9e64",   -- Parameter text color
      bg = "#2e3440",   -- Background color (optional)
      bold = true,      -- Bold parameter name
      underline = true, -- Add an underline
    })
  end,
}
