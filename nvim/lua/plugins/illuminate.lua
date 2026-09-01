return {
  "RRethy/vim-illuminate",
  event = "VimEnter",
  config = function()
    require("illuminate").configure()

    local function set_illuminate_hl()
      vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#333333", underline = false, bold = true })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#333333", underline = false, bold = true })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#333333", bold = true, underline = false })
    end

    set_illuminate_hl()

    -- Re-apply when changing colorschemes
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = set_illuminate_hl,
    })
  end,
}
