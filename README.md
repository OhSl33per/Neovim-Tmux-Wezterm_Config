# .config

Personal dotfiles repository for `~/.config` for both Windows w/ WSL & Mac; pieces are in place to configure standalone Windows & Linux, but nothing yet implemented.

## Tracked contents

| Path | Purpose |
|---|---|
| `nvim/init.lua` | Neovim configuration |
| `nvim/lazy-lock.json` | Plugin lockfile for `lazy.nvim` |
| `tmux/tmux.conf` | tmux configuration |
| `tmux/plugins/*` | contains all plugins for `tmux`
| `westerm-COPY/wezterm.lua` | WezTerm terminal configuration |
| `wslu/baseexec`, `wslu/oemcp`, `wslu/triggered_time` | WSL utilities (`wslu`) state files |

## Ignored (not tracked)

Per `.gitignore`, the following directories are excluded from version control because they contain
local credentials/session state rather than shareable config:

- `gh/` — GitHub CLI config and auth (`config.yml`, `hosts.yml`)
- `github-copilot/` — GitHub Copilot CLI auth database and session data
- `bob/` - Bob neovim version manager as each os can get this separately

## Usage

Clone this repo to `~/.config` (or symlink individual files) to restore this environment's
neovim, tmux, and WezTerm setup on a new machine.
