set   termencoding=cp932
set   mouse=a
set   path+=/usr/include/**
set   ruler
set   hlsearch
set nonumber
set noswapfile
set notitle
set   wildmenu
set   backspace=indent,eol,start
set   encoding=utf-8
set   fileencoding=utf-8
set   fileencodings=ucs-bom,utf-8,cp932

if has('syntax')
    syntax on
endif
if has('unnamedplus')
    set clipboard&
    set clipboard^=unnamedplus
endif
filetype indent plugin on
