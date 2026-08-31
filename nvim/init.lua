vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- local currentColorTheme = "github-theme"
local currentColorScheme = "github_dark_default"

-- Auto-recover swap files silently and delete the swap after recovery
vim.o.swapfile = false

-- enable persistent undo across sessions
vim.o.undofile = true

vim.o.number = true
-- vim.o.relativenumber = true

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
			{ out, "WarningMsg" },
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

vim.cmd("colorscheme " .. currentColorScheme)

local function set_dim_hl()
	-- vim.api.nvim_set_hl(0, "Twilight", { fg = "#363636" })
	vim.api.nvim_set_hl(0, "MarkSignHL", { fg = "#ff8400", bold = true })
	vim.api.nvim_set_hl(0, "MarksignNumHL", { fg = "#ff8400", bold = true })
end
set_dim_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_dim_hl })

-- Create a custom group for inactive windows (e.g., darker background, dim text)
local inactiveConfig = {
	bg = "#242424", -- Darker background
	fg = "#6c7086", -- Muted text
	blend = 10,
}
vim.api.nvim_set_hl(0, "CustomInactive", inactiveConfig)
vim.api.nvim_set_hl(0, "NeoTreeNormalNC", inactiveConfig)
vim.o.winhighlight = "Normal:Normal,NormalNC:CustomInactive"

vim.api.nvim_create_autocmd({ "WinNew", "WinEnter" }, {
	callback = function()
		vim.wo.winhighlight = "Normal:Normal,NormalNC:CustomInactive"
	end,
})

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
-- vim.o.guicursor = "a:blinkwait700-blinkoff400-blinkon250"
vim.o.guicursor = "n-v-c-sm:block-blinkwait700-blinkoff400-blinkon250,"
	.. "i-ci-ve:ver25-blinkwait700-blinkoff400-blinkon250,"
	.. "r-cr-o:hor20-blinkwait700-blinkoff400-blinkon250"

-- Cusor LINE
vim.o.cursorline = true
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#171717"})
vim.o.cursorlineopt = "number"
vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "#00ff1a", fg = "#000000" })

-- local cursorline_group = vim.api.nvim_create_augroup("DynamicCursorLine", { clear = true })

-- -- Enable cursorline in the active window when focused
-- vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "FocusGained", "TermOpen" }, {
-- 	group = cursorline_group,
-- 	callback = function()
-- 		-- Optional: don't show cursorline in terminal windows
-- 		if vim.bo.buftype == "terminal" then
-- 			vim.opt_local.cursorline = false
-- 			return
-- 		end
-- 		vim.opt_local.cursorline = true
-- 	end,
-- })
--
-- -- Disable cursorline when leaving a window or switching to another Tmux pane
-- vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "FocusLost", "TermLeave" }, {
-- 	group = cursorline_group,
-- 	callback = function()
-- 		vim.opt_local.cursorline = false
-- 	end,
-- })
--
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

-- ### MOVE LINES MOTIONS ###
-- Normal mode
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
-- Insert mode
-- vim.keymap.set('i', '<A-j>' , '<Esc>:m .+1<CR>==gi', { desc = 'Move line down' })
-- vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { desc = 'Move line up' })
-- Visual mode
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ### DUPLICATE LINES ###
-- Normal mode: duplicate line below / above
vim.keymap.set("n", "gj", ":copy .<CR>==", { desc = "Duplicate line down" })
vim.keymap.set("n", "gk", ":copy .-1<CR>==", { desc = "Duplicate line up" })
-- Insert mode
-- vim.keymap.set('i', '<A-S-j>', '<Esc>:copy .<CR>==gi', { desc = 'Duplicate line down' })
-- vim.keymap.set('i', '<A-S-k>', '<Esc>:copy .-1<CR>==gi', { desc = 'Duplicate line up' })
-- Visual mode: duplicate selection below / above
vim.keymap.set("v", "<A-S-j>", ":copy '><CR>gv=gv", { desc = "Duplicate selection down" })
vim.keymap.set("v", "<A-S-k>", ":copy '<-1<CR>gv=gv", { desc = "Duplicate selection up" })

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Open :messages in a copyable scratch buffer
vim.keymap.set("n", "<leader>vm", function()
	local lines = vim.fn.split(vim.fn.execute("messages"), "\n")
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].filetype = "log"
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = math.floor(vim.o.columns * 0.8),
		height = math.floor(vim.o.lines * 0.6),
		row = math.floor(vim.o.lines * 0.2),
		col = math.floor(vim.o.columns * 0.1),
		style = "minimal",
		border = "rounded",
		title = " Messages ",
		title_pos = "center",
	})
	vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = buf, silent = true })
end, { desc = "View messages in copyable buffer" })

-- Replace selected text across entire buffer
vim.keymap.set("v", "<leader>rx", function()
	vim.cmd('normal! "zy')
	local selected = vim.fn.getreg("z")
	local replacement = vim.fn.input("Replace with: ")
	vim.cmd("%s/" .. vim.fn.escape(selected, "/\\") .. "/" .. replacement .. "/g")
end, { desc = "Replace selection across buffer" })

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
-- Copy buffer to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>qc", function()
	vim.cmd("%y+")
	vim.notify("Buffer copied to clipboard", vim.log.levels.INFO)
end, { desc = "Yank Entire Buffer" })

-- Copy file info to system clipboard
vim.keymap.set("n", "<leader>wn", function()
	local name = vim.fn.expand("%:t")
	vim.fn.setreg("+", name)
	vim.notify("Copied filename: " .. name)
end, { desc = "Copy filename" })

vim.keymap.set("n", "<leader>wp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	vim.notify("Copied full path: " .. path)
end, { desc = "Copy full path" })

vim.keymap.set("n", "<leader>wr", function()
	local path = vim.fn.expand("%:.")
	vim.fn.setreg("+", path)
	vim.notify("Copied relative path: " .. path)
end, { desc = "Copy relative path" })

vim.keymap.set("n", "<leader>wd", function()
	local dir = vim.fn.expand("%:p:h")
	vim.fn.setreg("+", dir)
	vim.notify("Copied directory: " .. dir)
end, { desc = "Copy file directory" })
-- Paste from system clipboard
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })

vim.o.foldcolumn = "0" -- statuscol.nvim renders the fold column via builtin.foldfunc
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

vim.opt.fillchars:append({
	foldopen = "⌄",
	foldclose = "›",
	foldsep = "│",
})

vim.opt.diffopt:append({
	"algorithm:histogram", -- Improves diff accuracy
	"indent-heuristic", -- Keeps code context aligned
	"vertical", -- Forces vertical splits
	"linematch:60", -- Better line-by-line alignment
})

vim.keymap.set("n", "<leader>xc", ":cclose<CR>", { desc = "Close quickfix" })

vim.keymap.set({ "n", "v" }, "<Leader>j", "J", { noremap = true, silent = true, desc = "Join Lines" })

vim.keymap.set({ "n", "v" }, "J", "10j", { noremap = true, silent = true, desc = "Jump down 10 lines" })
vim.keymap.set({ "n", "v" }, "K", "10k", { noremap = true, silent = true, desc = "Jump up 10 lines" })
vim.keymap.set({ "n", "v" }, "H", "10h", { noremap = true, silent = true, desc = "Jump left 10 chars" })
vim.keymap.set({ "n", "v" }, "L", "10l", { noremap = true, silent = true, desc = "Jump right 10 chars" })

vim.keymap.set({ "n", "v" }, "<leader>ss", ":w<CR>", { desc = "Save File [format]" })
vim.keymap.set({ "n", "v" }, "<leader>sS", ":noautocmd w<CR>", { desc = "Save File [NO format]" })
vim.keymap.set({ "n", "v" }, "<leader>sq", ":wq<CR>", { desc = "Save File & Quit [format]" })
vim.keymap.set({ "n", "v" }, "<leader>sQ", ":noautocmd wq<CR>", { desc = "Save File & Quit [NO format]" })

if is_wsl == true then
	vim.g.clipboard = {
		name = "WslClipboard",
		copy = {
			["+"] = "clip.exe",
			["*"] = "clip.exe",
		},
		paste = {
			["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
			["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
		},
		cache_enabled = 0,
	}
end

-- local function load_grep_matches_to_buffer(pattern, root)
--   root = root or vim.loop.cwd()
--   local handle = io.popen(string.format("rg -w --files-with-matches %q %q", pattern, root))
--   if not handle then
--     vim.notify("Failed to run ripgrep", vim.log.levels.ERROR)
--     return
--   end
--   local result = handle:read("*a")
--   handle:close()
--   local files = {}
--   for file in result:gmatch("[^\r\n]+") do
--     file = vim.fn.fnamemodify(vim.trim(file), ":p") -- ensure absolute path, trim whitespace
--     if vim.fn.filereadable(file) == 1 then
--       local bufnr = vim.fn.bufadd(file)
--       vim.fn.bufload(bufnr)
--       vim.bo[bufnr].buflisted = true -- Make sure buffer is listed!
--       table.insert(files, file)
--     end
--   end
--   if #files == 0 then
--     vim.notify("No files found matching: " .. pattern, vim.log.levels.INFO)
--     return
--   end
--   vim.notify(("Loaded %d files into buffer for pattern: %s"):format(#files, pattern))
-- end
--
-- vim.api.nvim_create_user_command("LoadGrepBuffers", function.o.)
--   load_grep_matches_to_buffer.o..args)
-- end, { nargs = 1, complete = "file" })
--
-- vim.keymap.set("n", "<leader>fw", function()
--   local cword = vim.fn.expand("<cword>")
--   load_grep_matches_to_buffer(cword)
-- end, { desc = "Load into buffers all files matching word under cursor" })
