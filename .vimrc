set nocompatible
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
call vundle#end()
filetype plugin indent on
syntax on
let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'
let g:pydiction_menu_height = 3

"Who likes swap files?
set noswapfile

" custom color scheme
colorscheme custom

" remove trailing whitespaces on :w
autocmd BufWritePre * %s/\s\+$//e

"make into a real edito
syntax on
syntax enable
set autoindent
set tabstop=4
set softtabstop=4 expandtab
set shiftwidth=4
set expandtab
set ai
set number
set hlsearch
set ruler
set wrap!
highlight Comment ctermfg=green

"make into vim
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
