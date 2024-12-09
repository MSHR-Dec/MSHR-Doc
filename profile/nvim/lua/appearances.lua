-- theme
vim.cmd.colorscheme('hybrid')

-- nvim-treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = { 'go', 'hcl', 'lua', 'vim', 'vimdoc', 'json', 'yaml', 'markdown', 'markdown_inline' },
  highlight = {
    enable = true,
  },
}

-- nerdtree
vim.g.NERDTreeShowLineNumbers = 1
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeWinSize = 50
vim.keymap.set('n', '<c-l>', '<cmd>NERDTreeToggle<cr>', { remap = true })

-- vim-airline
vim.g.airline_left_sep = '▶'
vim.g.airline_right_sep = '◀'
vim.g.airline_theme = 'raven'

-- bufferline.nvim
vim.opt.termguicolors = true
require('bufferline').setup()

-- vim-gitgutter
vim.g.gitgutter_preview_win_floating = 1
vim.keymap.set('n', 'ghs', '<Plug>(GitGutterStageHunk)')
vim.keymap.set('n', 'ghu', '<Plug>(GitGutterUndoHunk)')
vim.keymap.set('n', 'ghp', '<Plug>(GitGutterPreviewHunk)')

-- indentmini.nvim
vim.cmd.highlight('IndentLine guifg=#767676')
vim.cmd.highlight('IndentLineCurrent guifg=#af00ff')
require("indentmini").setup()
