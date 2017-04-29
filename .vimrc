set mouse=
set path+=/usr/include/**
set ruler
set hlsearch
set nonumber
set noswapfile
set notitle
set wildmenu
set backspace=indent,eol,start
syntax on
filetype indent plugin on
set encoding=utf-8
set fileencoding=utf-8

if exists('*plug#begin')
    call plug#begin('~/.vim/plugged')
    Plug 'scrooloose/nerdtree', { 'on':  ['NERDTreeToggle'] }
    call plug#end()
endif
