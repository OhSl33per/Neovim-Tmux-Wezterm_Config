local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Shell & Auto-Launch tmux
config.default_prog = { "wsl.exe", "bash", "-c", "cd ~ && tmux new-session" }

-- Appearance
config.color_scheme = "Cyberdream"
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 12.0
config.hide_tab_bar_if_only_one_tab = true

return config
