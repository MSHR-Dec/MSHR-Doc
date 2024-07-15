" vim plug
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug '/opt/homebrew/opt/fzf'
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

call plug#end()

" NERDTree
nnoremap <C-l> :NERDTree<CR>
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1

" FZF
set rtp+=/opt/homebrew/opt/fzf

" common
set number
set nowritebackup
set nobackup
set virtualedit=block
set backspace=indent,eol,start
set ambiwidth=double
set wildmenu
set ignorecase
set smartcase
set wrapscan
set incsearch
set hlsearch
set showmatch matchtime=1
set cinoptions+=:0
set cmdheight=2
set laststatus=2
set showcmd
set display=lastline
set listchars=tab:^\ ,trail:~
set history=10000
hi Comment ctermfg=3
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set guioptions-=T
set guioptions+=a
set guioptions-=m
set guioptions+=R
set showmatch
set smartindent
set noswapfile
set nofoldenable
set title
set hidden
set clipboard=unnamed,autoselect

map <C-Tab> :bn<CR>
map <C-S-Tab> :bp<CR>
nnoremap x "_x
nnoremap s "_s
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>
nnoremap <S-F> :%!jq .<CR><ESC>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-d> <Del>

set cursorline
highlight CursorLine cterm=underline ctermfg=NONE ctermbg=NONE
highlight CursorLine gui=underline guifg=NONE guibg=NONE

" theme
syntax on
set background=dark
colorscheme hybrid

