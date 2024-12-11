vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- options
vim.opt.ambiwidth = "double"
vim.opt.cinoptions:append(":0")
vim.opt.clipboard = { "unnamed" }
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.matchtime = 1
vim.opt.number = true
vim.opt.showmatch = true
vim.opt.shiftwidth = 0
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.title = true
vim.opt.updatetime = 400
vim.opt.writebackup = false

-- keymaps
vim.keymap.set("n", "x", "\"_x")
vim.keymap.set("n", "s", "\"_s")
vim.keymap.set("n", "<c-n>", "<cmd>bnext<cr>", { remap = true })
vim.keymap.set("n", "<c-p>", "<cmd>bprev<cr>", { remap = true })
vim.keymap.set("n", "<esc><esc>", "<cmd>nohlsearch<cr><ecs>", { remap = true })
vim.keymap.set("n", "<Leader>jq", "<cmd>jq%!jq .<cr><ecs>", { remap = true })
vim.keymap.set("n", "<c-h>", "<c-w>h")
vim.keymap.set("n", "<c-j>", "<c-w>j")
vim.keymap.set("n", "<c-k>", "<c-w>k")
vim.keymap.set("n", "<c-l>", "<c-w>l")
vim.keymap.set("n", "<c-down>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<c-left>", "<cmd>vertical resize -2<cr>")
vim.keymap.set("n", "<c-right>", "<cmd>vertical resize +2<cr>")
vim.keymap.set("n", "<c-up>", "<cmd>resize -2<cr>")
vim.keymap.set("n", "<c-down>", "<cmd>resize +2<cr>")
vim.keymap.set("n", "<c-left>", "<cmd>vertical resize -2<cr>")
vim.keymap.set("n", "<c-right>", "<cmd>vertical resize +2<cr>")
vim.keymap.set("t", "<c-up>", "<cmd>resize -2<cr>")
vim.keymap.set("t", "<c-down>", "<cmd>resize +2<cr>")
vim.keymap.set("t", "<c-left>", "<cmd>vertical resize -2<cr>")
vim.keymap.set("t", "<c-right>", "<cmd>vertical resize +2<cr>")
vim.keymap.set("t", "<c-j>", "<cmd>wincmd j<cr>")
vim.keymap.set("t", "<c-k>", "<cmd>wincmd k<cr>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
