-- toggleterm.nvim
require('toggleterm').setup{
  size = vim.o.lines * 0.35,
  open_mapping = [[<c-t>]],
  direction = 'horizontal',
  shell = '/bin/bash --login',
}
vim.keymap.set('t', '<F12>', [[<c-\><c-n>]], { noremap = true })

local Terminal = require('toggleterm.terminal').Terminal
local tig = Terminal:new({
  cmd = '/bin/bash --login',
  dir = vim.fn.getcwd(),
  direction = 'float',
  hidden = true,
})
function Tig()
  tig:toggle()
end
vim.api.nvim_set_keymap('n', '<Leader>tig', '<cmd>lua Tig()<cr>', { noremap = true })

-- fzf-lua
vim.keymap.set('n', '<Leader>grep', require('fzf-lua').grep)
vim.keymap.set('n', '<Leader>find', require('fzf-lua').grep_curbuf)
vim.keymap.set('n', '<Leader>file', require('fzf-lua').files)
vim.keymap.set('n', '<Leader>buf', require('fzf-lua').buffers)

-- memolist.vim
vim.g.memolist_path = '$HOME/.memo'
vim.keymap.set('n', '<Leader>mn', '<cmd>MemoNew<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>ml', '<cmd>MemoList<cr>', { noremap = true })
vim.keymap.set('n', '<Leader>mg', '<cmd>MemoGrep<cr>', { noremap = true })
