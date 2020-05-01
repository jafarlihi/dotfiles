" https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')
Plug 'easymotion/vim-easymotion'
Plug 'fxn/vim-monochrome'
Plug 'junegunn/fzf'
Plug 'majutsushi/tagbar'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'scrooloose/syntastic'
call plug#end()

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
" Loads plugin for extending '%' key tag matching functionality
runtime! macros/matchit.vim

" Make navigation between splits easier
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Toggle relative line numbering with Ctrl-B
function! RelativeNumberingToggle()
    if &rnu == 1
        set norelativenumber
    else
        set relativenumber
    endif
endfunc
nnoremap <C-b> :call RelativeNumberingToggle()<cr>

" File extension to filetype associations
autocmd BufNewFile,BufRead *.nasm set filetype=nasm
autocmd BufNewFile,BufRead *.jad set filetype=java

" Colorschemes
let s:default_colorscheme = 'default'
let s:alternative_colorscheme = 'monochrome'
execute "colorscheme ".s:default_colorscheme
" Cycle colorschemes with F5
function! CycleColorschemes()
    if g:colors_name == s:default_colorscheme
        execute "colorscheme ".s:alternative_colorscheme
    else
        execute "colorscheme ".s:default_colorscheme
    endif
endfunc
nnoremap <F5> :call CycleColorschemes()<cr>

" Make background transparent
hi Normal guibg=NONE ctermbg=NONE

" Open FZF with Ctrl-P
nnoremap <C-p> :FZF<cr>

" Open Tagbar with Ctrl-C
nnoremap <C-c> :TagbarToggle<CR>

" Define libclang location for clang_complete plugin
"let g:clang_library_path='/usr/lib64/libclang.so'

" Run :RustFmt on save automatically
"let g:rustfmt_autosave = 1

let g:syntastic_go_checkers = ['go', 'golint', 'govet', 'errcheck', 'gofmt']
