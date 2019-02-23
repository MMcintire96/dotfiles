

"Using vundle"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'flazz/vim-colorschemes'
call vundle#end()
filetype plugin indent on


"Who likes swap files?
set noswapfile


"make into a real editor
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
