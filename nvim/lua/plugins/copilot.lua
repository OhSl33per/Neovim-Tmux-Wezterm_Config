return {
  "github/copilot.vim",
  enabled = false,
  config = function()
    vim.g.copilot_idle_delay = 250 -- ms debounce before requesting a suggestion
  end,
}
