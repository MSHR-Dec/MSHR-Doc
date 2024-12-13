local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('HoNamDuong/hybrid.nvim')
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
Plug('neovim/nvim-lspconfig')
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-cmdline')
Plug('hashivim/vim-terraform')

vim.call('plug#end')
