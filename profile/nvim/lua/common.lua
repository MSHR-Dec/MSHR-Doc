vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- options
vim.opt.ambiwidth = 'double'
vim.opt.cinoptions:append(":0")
vim.opt.clipboard = { 'unnamed' }
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
vim.keymap.set('n', 'x', '"_x')
vim.keymap.set('n', 's', '"_s')
vim.keymap.set('n', '<c-n>', '<cmd>bnext<cr>', { remap = true })
vim.keymap.set('n', '<c-p>', '<cmd>bprev<cr>', { remap = true })
vim.keymap.set('n', '<esc><esc>', '<cmd>nohlsearch<cr><ecs>', { remap = true })
vim.keymap.set('n', '<Leader>jq', '<cmd>jq%!jq .<cr><ecs>', { remap = true })
