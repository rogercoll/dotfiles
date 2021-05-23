" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ctrlpvim/ctrlp.vim'
Plug 'NLKNguyen/papercolor-theme'

call plug#end()

" Front
syntax on
set background=dark
colorscheme PaperColor
set encoding=utf-8


" no swapfiles
set noswapfile

" show line numbers
set number
set relativenumber

" incremental search, case insensitive when using lower
set incsearch
set ignorecase
set smartcase

" add yaml stuffs
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" Habits
:let mapleader = ","
:imap jj <Esc>
