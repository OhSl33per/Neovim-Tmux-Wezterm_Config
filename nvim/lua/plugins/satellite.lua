return {
  "lewis6991/satellite.nvim",
  config = function()
    require("satellite").setup({
      width = 6, -- currently does not work, but will hopefully in future version / release
    })
    vim.api.nvim_set_hl(0, "SatelliteBar",        { bg = "#428bff" })
    vim.api.nvim_set_hl(0, "SatelliteBackground", { bg = "#525252" })
  end,
}
