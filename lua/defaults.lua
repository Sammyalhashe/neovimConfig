--> aliases for config
local api    = vim.api
local g      = vim.g
local keymap = vim.keymap
local set    = vim.opt
local wo     = vim.wo

--> encoding
set.encoding       = "utf-8"
vim.scriptencoding = "utf-8"

--> I don't use backups
set.backup      = false
set.writebackup = false
set.swapfile    = false

--> mapleaders
g.mapleader      = " "
g.maplocalleader = " "

--> easy mapping for executing shell commands
keymap.set("n", "!", ":!")

--> spell check
vim.spelllang = "en,cjk"

--> clipboard
set.clipboard:append("unnamedplus")

--> prevent --INSERT-- from showing which conflicts with statuslines
vim.noshowmode = true

--> colourcolumn (English/Canadian spelling only)
wo.colorcolumn = "80"

--> line numbers
wo.number         = true
wo.relativenumber = true

--> spaces/tabs
set.expandtab  = true
set.smarttab   = true
set.tabstop    = 4
set.shiftwidth = 4

--> split navigation
keymap.set("n", "<c-l>", "<c-w>l")
keymap.set("n", "<c-k>", "<c-w>k")
keymap.set("n", "<c-j>", "<c-w>j")
keymap.set("n", "<c-h>", "<c-w>h")

--> nowrap
set.wrap = false

--> more characters will be sent to teh screen for redrawing
set.ttyfast = true

--> new splits will be at bottom/right of screen
set.splitbelow = true
set.splitright = true

--> terminal mode TODO Maybe move this to own config file.
keymap.set("t", "<esc>", "<c-\\><c-n>")
-- I don't want the terminal to have numbers
local openterminalaugroup = api.nvim_create_augroup(
    "terminal_cmds",
    { clear = true }
)
api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    group   = openterminalaugroup,
    command = "setlocal nonumber"
})

api.nvim_create_user_command("TT", "tabnew | term", {})
api.nvim_create_user_command("VT", "vsplit | term", {})
api.nvim_create_user_command("ST", "split | term", {})

--> :noh convinience map
keymap.set("n", "<leader><cr>", "<cmd>noh<cr>")
