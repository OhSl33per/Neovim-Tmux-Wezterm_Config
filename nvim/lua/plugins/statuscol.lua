return {
  "luukvbaal/statuscol.nvim",
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      segments = {

        -- Git signs column
        {
          sign = {
            namespace = { "gitsigns" },
            name = { "GitSigns.*" },
            maxwidth = 1,
            colwidth = 2,
            auto = false, -- Set to true if you want the column to hide when there are no git changes
          },
          click = "v:lua.ScSa",
        },

        -- Marks + diagnostics + everything else
        {
          sign = {
            namespace = { ".*" },
            name = { ".*" },
            maxwidth = 1,
            colwidth = 2,
            auto = true,
          },
          click = "v:lua.ScSa",
        },

        -- Line numbers
        {
          text = { builtin.lnumfunc, " " },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        },
        -- folds
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
      },
    })
  end,
}
