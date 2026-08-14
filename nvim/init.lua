vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Auto-recover swap files silently and delete the swap after recovery
vim.opt.swapfile = false

-- enable persistent undo accross sessions
vim.opt.undofile = true

vim.opt.number = true
-- vim.opt.relativenumber = true

local sysname = vim.uv.os_uname().sysname

local is_mac = sysname == "Darwin"
local is_linux = sysname == "Linux"
local is_win = sysname == "Windows_NT"

local is_wsl = vim.fn.has("wsl") == 1
    or (is_linux and vim.fn.readfile("/proc/version")[1]:lower():find("microsoft") ~= nil)
print("Source System:", sysname, " -- ", "Is WSL:", is_wsl)
local v = vim.version()
print(string.format("Neovim %d.%d.%d", v.major, v.minor, v.patch))

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "carbonfox", "habamax" } },
  checker = { enabled = true },
})


vim.cmd("colorscheme github_dark_default")

vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", {
  fg = "#00ff1a",
  italic = true,
})

-- Trouble displays diagnostics in a list; Neovim renders them in the buffer.
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
    spacing = 2,
  },
  signs = false,
  underline = true,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "if_many",
  },
})

-- Cursor Settings
-- vim.opt.guicursor = "a:blinkwait700-blinkoff400-blinkon250"
vim.opt.guicursor = "n-v-c-sm:block-blinkwait700-blinkoff400-blinkon250," ..
    "i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250," ..
    "r-cr-o:hor20-blinkwait700-blinkoff400-blinkon250"

-- Diagnostic highlight colors
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#ff1500", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#ff7700", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#02cae0", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#e002d9", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#ff1500" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#ff7700" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#02cae0" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#e002d9" })

-- Optional: disable arrow keys to force hjkl habit
vim.keymap.set("n", "<Up>", "<Nop>", { desc = "Disable Up arrow" })
vim.keymap.set("n", "<Down>", "<Nop>", { desc = "Disable Down arrow" })
vim.keymap.set("n", "<Left>", "<Nop>", { desc = "Disable Left arrow" })
vim.keymap.set("n", "<Right>", "<Nop>", { desc = "Disable Right arrow" })

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
-- Paste from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

vim.opt.diffopt:append({
  "algorithm:histogram", -- Improves diff accuracy
  "indent-heuristic",    -- Keeps code context aligned
  "vertical",            -- Forces vertical splits
  "linematch:60",        -- Better line-by-line alignment
})

vim.keymap.set("n", "<leader>xc", ":cclose<CR>", { desc = "Close quickfix" })

vim.keymap.set({ "n", "v" }, "<Leader>j", "J", { noremap = true, silent = true, desc = "Join Lines" })

local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "v" }, "J", "10j", { desc = "Jump down 10 lines" }, opts)
vim.keymap.set({ "n", "v" }, "K", "10k", { desc = "Jump up 10 lines" }, opts)
vim.keymap.set({ "n", "v" }, "H", "10h", { desc = "Jump left 10 chars" }, opts)
vim.keymap.set({ "n", "v" }, "L", "10l", { desc = "Jump right 10 chars" }, opts)

if is_wsl == true then
  vim.g.clipboard = {
    name = "WslClipboard",
    copy = {
      ["+"] = "clip.exe",
      ["*"] = "clip.exe",
    },
    paste = {
      ["+"] =
      'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
      ["*"] =
      'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    },
    cache_enabled = 0,
  }
end

local function load_grep_matches_to_buffer(pattern, root)
  root = root or vim.loop.cwd()
  local handle = io.popen(string.format("rg -w --files-with-matches %q %q", pattern, root))
  if not handle then
    vim.notify("Failed to run ripgrep", vim.log.levels.ERROR)
    return
  end
  local result = handle:read("*a")
  handle:close()
  local files = {}
  for file in result:gmatch("[^\r\n]+") do
    file = vim.fn.fnamemodify(vim.trim(file), ":p") -- ensure absolute path, trim whitespace
    if vim.fn.filereadable(file) == 1 then
      local bufnr = vim.fn.bufadd(file)
      vim.fn.bufload(bufnr)
      vim.bo[bufnr].buflisted = true -- Make sure buffer is listed!
      table.insert(files, file)
    end
  end
  if #files == 0 then
    vim.notify("No files found matching: " .. pattern, vim.log.levels.INFO)
    return
  end
  vim.notify(("Loaded %d files into buffer for pattern: %s"):format(#files, pattern))
end

vim.api.nvim_create_user_command("LoadGrepBuffers", function(opts)
  load_grep_matches_to_buffer(opts.args)
end, { nargs = 1, complete = "file" })

vim.keymap.set("n", "<leader>fw", function()
  local cword = vim.fn.expand("<cword>")
  load_grep_matches_to_buffer(cword)
end, { desc = "Load into buffers all files matching word under cursor" })
