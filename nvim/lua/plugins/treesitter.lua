return {
  "nvim-treesitter/nvim-treesitter",
  tag = "v0.9.3",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "jsonc",
        "html",
        "css",
        "python",
        "c_sharp",
        "markdown",
        "markdown_inline",
      },
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      disable = { "lua" },
    })
  end,
}
