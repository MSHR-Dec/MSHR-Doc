local vim = vim

-- vim-plug 本体が無ければ取得（初回のみ / setup.sh でも導入している）
local plugvim = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'
if vim.fn.filereadable(plugvim) == 0 then
  vim.fn.system({
    'curl', '-fLo', plugvim, '--create-dirs',
    'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim',
  })
end

local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- appearance
Plug('Mofiqul/dracula.nvim')
Plug('nvim-treesitter/nvim-treesitter', { ['branch'] = 'master', ['do'] = ':TSUpdate' })
Plug('nvim-lualine/lualine.nvim')
Plug('akinsho/bufferline.nvim')
Plug('petertriho/nvim-scrollbar')
Plug('nvimdev/indentmini.nvim')
Plug('ryanoasis/vim-devicons')
Plug('nvim-tree/nvim-web-devicons')

-- filer
Plug('preservim/nerdtree')
Plug('tiagofumo/vim-nerdtree-syntax-highlight')

-- git
Plug('airblade/vim-gitgutter')
Plug('tpope/vim-fugitive')

-- edit
Plug('tpope/vim-surround')
Plug('roobert/search-replace.nvim')

-- tools
Plug('akinsho/toggleterm.nvim', { ['tag'] = '*' })
Plug('ibhagwan/fzf-lua', { ['branch'] = 'main' })
Plug('glidenote/memolist.vim')

-- filetype
Plug('hashivim/vim-terraform')

vim.call('plug#end')

-- 未取得なら起動後に自動インストール
if vim.fn.isdirectory(vim.fn.stdpath('data') .. '/plugged/dracula.nvim') == 0 then
  vim.cmd('autocmd VimEnter * ++once PlugInstall --sync | source $MYVIMRC')
end
