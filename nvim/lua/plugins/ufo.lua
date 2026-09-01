return {
  "kevinhwang91/nvim-ufo",
  dependencies = "kevinhwang91/promise-async",
  lazy = false,
  config = function()
    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
      end,
    })
  end,
  keys = {
    {
      "zR",
      function() require("ufo").openAllFolds() end,
      desc = "Open all folds",
    },
    {
      "zM",
      function() require("ufo").closeAllFolds() end,
      desc = "Close all folds",
    },
    {
      "zL",
      function()
        local level = vim.fn.foldlevel(".")
        if level > 0 then
          require("ufo").closeFoldsWith(level - 1)
        else
          vim.notify("No fold at cursor", vim.log.levels.WARN)
        end
      end,
      desc = "Close folds at cursor indent level",
    },
  },
}
