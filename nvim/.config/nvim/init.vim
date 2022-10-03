" General settings
set nocompatible
set clipboard=unnamedplus
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set mouse=a
set hlsearch
set incsearch
set wrap
set ruler
set wildmenu
set number
set norelativenumber
set laststatus=2
set scrolloff=1
set sidescrolloff=5
set formatoptions+=j
set display+=lastline
set history=1000
set tabpagemax=20
set autoindent
set autoread
set sessionoptions-=options
set shell=/bin/bash
set backspace=indent,eol,start
set encoding=utf-8
set spelllang=en_us
"set showmatch

" Enable syntax highlighting
syntax on
" Enables filetype detection, filetype-specific plugin loading, and
" filetype-specific indent file loading
filetype plugin indent on

" Open FZF with Ctrl-P
nnoremap <C-p> :FZF<cr>

"lua require('plugins')

