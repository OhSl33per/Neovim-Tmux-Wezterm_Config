return {
  "gelguy/wilder.nvim",
  event = "CmdlineEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local wilder = require("wilder")
    wilder.setup({ modes = { ":", "/", "?" } })

    wilder.set_option("pipeline", {
      wilder.branch(
        wilder.cmdline_pipeline({
          fuzzy = 1,        -- fuzzy match commands, filenames, etc.
          language = "vim", -- avoid requiring python3/pynvim remote plugin support
        }),
        wilder.vim_search_pipeline() -- fuzzy match against buffer lines for / and ?
      ),
    })

    wilder.set_option(
      "renderer",
      wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
        highlighter = wilder.basic_highlighter(),
        left = { " ", wilder.popupmenu_devicons() },
        right = { " ", wilder.popupmenu_scrollbar() },
        border = "rounded",
      }))
    )
  end,
}
