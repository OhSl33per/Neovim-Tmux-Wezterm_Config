local wezterm = require("wezterm")
local config = wezterm.config_builder()

local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_mac     = wezterm.target_triple:find("darwin") ~= nil
local is_linux   = wezterm.target_triple:find("linux") ~= nil

-- Check if WezTerm itself is running inside WSL or launching WSL
local is_wsl = false

-- Way A: Check if wezterm is executing under Linux kernel with Microsoft/WSL headers
if is_linux then
  local f = io.open("/proc/version", "r")
  if f then
    local content = f:read("*all"):lower()
    f:close()
    if content:find("microsoft") or content:find("wsl") then
      is_wsl = true
    end
  end
end

-- Shell & Auto-Launch tmux
if is_windows then
  local has_wsl = false
  local ok, _, _ = wezterm.run_child_process({ "wsl.exe", "-l", "-q" })
  if ok then
    has_wsl = true
  end

  if has_wsl then
    config.default_prog = { "wsl.exe", "bash", "-c", "cd ~ && tmux new-session" }
  end
end

if is_mac then
  config.default_prog = { "/bin/zsh", "-l", "-c", "/opt/homebrew/bin/tmux new-session" }
end

print(is_windows)

-- Appearance
config.color_scheme = "cyberpunk"
config.colors = {
	background = "#000000",
}
config.font = wezterm.font("FiraCode Nerd Font")
config.font_size = 12.0
config.hide_tab_bar_if_only_one_tab = true

return config
