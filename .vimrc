set mouse=
set path+=/usr/include/**
set ruler
set hlsearch
set nonumber
set noswapfile
set notitle
set wildmenu
set backspace=indent,eol,start
set encoding=utf-8
set fileencoding=utf-8

if has('syntax')
    syntax on
endif
if exists("did_load_ftplugin")
    filetype indent plugin on
endif

if exists('*plug#begin')
    call plug#begin('~/.vim/plugged')
    Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle'] }
    call plug#end()
endif
