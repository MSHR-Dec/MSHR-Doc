local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('HoNamDuong/hybrid.nvim')
Plug('Mofiqul/dracula.nvim')
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })
Plug('preservim/nerdtree')
Plug('ryanoasis/vim-devicons')
Plug('vim-airline/vim-airline')
Plug('vim-airline/vim-airline-themes')
Plug('akinsho/bufferline.nvim')
Plug('airblade/vim-gitgutter')
Plug('tpope/vim-fugitive')
Plug('nvimdev/indentmini.nvim')
Plug('akinsho/toggleterm.nvim', { ['tag'] = '*' })
Plug('ibhagwan/fzf-lua', { ['branch'] = 'main' })
Plug('glidenote/memolist.vim')

vim.call('plug#end')
