" vim:set foldmethod=marker:
set nocompatible

" Utility functions {{{

function! s:set_indent(size, expand)
    if a:expand == 1
        set   expandtab
    else
        set noexpandtab
    endif
    let &tabstop = a:size
    let &softtabstop = a:size
    let &shiftwidth = a:size
endfunction

" }}}

" OS dependent workarounds {{{
if has('win32') || has('win64')
    set   termencoding=cp932
    " :PlugUpdate fails if `pwsh.exe` is set for shell...
    " https://www.reddit.com/r/neovim/comments/gbb2g3/wierd_vimplug_error_messages/g3n3vtl/
    "if executable('pwsh')
    "    set shell=pwsh.exe
    "endif

    " Use tee command on Windows too.
    if executable('tee')
        set shellpipe=2>&1\|\ tee
    endif
endif
if has('linux')
set   path+=/usr/include/**
endif
" }}}

" File & Edit {{{
set   backspace=indent,eol,start
set   encoding=utf-8
set   fileencoding=utf-8
set   fileencodings=ucs-bom,utf-8,cp932
set   virtualedit=block
set nobackup
set nowritebackup
set noswapfile
set noundofile
"if has('unnamedplus')
"    set clipboard&
"    set clipboard^=unnamedplus
"endif
set clipboard=

" }}}

" User Interface & Appearence {{{
set notitle
set noruler
set   number
set   relativenumber
set   statusline =%n\ %<%f%R%M,%{&ff}%y%h%w%q
set   statusline+=%=\ %(%l,%c%V%)\ %p%%
set   statusline+=\ %#warningmsg#
set   statusline+=%*
set   splitright
set   scrolloff=2
set   updatetime=500
set   wildmenu
set   wildmode=longest:full
if v:version >= 900
    set   wildoptions=pum
endif
set   mouse=
set   completeopt=menuone,noinsert,noselect
set nolist
set   listchars=tab:╌╌>,trail:␠
set   breakindent
set   breakindentopt=shift:2,sbr
set   showbreak=↳
set laststatus=2

" }}}

" Search {{{
set   hlsearch
set   ignorecase
set   smartcase
set nowrapscan

" }}}

" Indentation {{{
set shiftround
call s:set_indent(4, 1)
augroup indent
    autocmd!
    autocmd FileType gitconfig       call s:set_indent(8, 0)
    autocmd FileType make            call s:set_indent(8, 0)
    autocmd FileType markdown        call s:set_indent(2, 0)
    autocmd FileType go              call s:set_indent(4, 0)
    autocmd FileType css             call s:set_indent(2, 1)
    autocmd FileType html            call s:set_indent(2, 1)
    autocmd FileType javascript      call s:set_indent(2, 1)
    autocmd FileType javascriptreact call s:set_indent(2, 1)
    autocmd FileType typescript      call s:set_indent(2, 1)
    autocmd FileType typescriptreact call s:set_indent(2, 1)
augroup END

" }}}

" Folding {{{
" https://superuser.com/a/567391/2370467
:autocmd BufWinEnter * let &foldlevel = max(map(range(1, line('$')), 'foldlevel(v:val)'))
" }}}

" Misc. {{{
if executable('rg')
    set   grepprg=rg\ --vimgrep
endif
set  wildignore =*.swp,*.~*
set  wildignore+=*.o,*.obj
set  wildignore+=*.so,*.dll
set  wildignore+=*.py[cod]
set  wildignore+=*.min.*
"autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
"highlight ExtraWhitespace ctermbg=red guibg=red
filetype indent plugin on

" }}}

" Plugins {{{
call plug#begin()
Plug 'tpope/vim-commentary',    { 'tag': '*' }
Plug 'tpope/vim-fugitive',      { 'tag': '*' }
Plug 'elkasztano/nushell-syntax-vim'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf',                  { 'tag': '*', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'editorconfig/editorconfig-vim', { 'tag': '*' }
Plug 'airblade/vim-gitgutter'
Plug 'machakann/vim-sandwich',        { 'tag': '*' }
call plug#end()

" }}}

syntax on

" Color scheme {{{
set t_Co=256
if has('termguicolors')
    set termguicolors
endif
if findfile("colors/onedark.vim", &rtp) != ""
    colorscheme onedark
endif

" }}} Color scheme

" (GitGutter) Use '≅' instead of '~_' for modified & removed line
let g:gitgutter_sign_modified_removed = '≅'

" Per filetype configurations {{{
augroup GoSettings
    autocmd!
    autocmd FileType go     setlocal makeprg=go
    autocmd FileType go     nmap<buffer>    \b :make build ./...<CR>
    autocmd FileType go     nmap<buffer>    \t :make test ./...<CR>
augroup END

augroup PythonSettings
    " Using pytest for unit testing.
    " Note that setting errorformat for pytest is not necessary because it's
    " the same as flake8's which should be provided by vim-polyglot.
    autocmd!
    autocmd FileType python setlocal errorformat=%f:%l:\ %m
    autocmd FileType python setlocal makeprg=python\ -m\ pytest\ $*
    autocmd FileType python nmap<buffer>    \t <Cmd>make<CR>
augroup END

augroup RustSettings
    autocmd!
    autocmd FileType rust   setlocal errorformat=%f:%l:%m
    autocmd FileType rust   setlocal makeprg=cargo\ $*
    autocmd FileType rust   nmap<buffer>    \b :make build --message-format=short<CR>
    autocmd FileType rust   nmap<buffer>    \t :make test<CR>
augroup END

augroup DiffSettings
    autocmd!

    " Show whitespace characters in diff mode
    autocmd OptionSet diff  if v:option_new == 1 |
        \   set   list |
        \ else |
        \   set nolist |
        \ endif
augroup END

augroup QuickFixSettings
    autocmd!
    autocmd FileType qf     nmap<buffer> q     <Cmd>q<CR>
    autocmd FileType qf     nmap<buffer> <C-[> <Cmd>q<CR>
    autocmd FileType qf     nmap<buffer> <Esc> <Cmd>q<CR>
augroup END

augroup HelpSettings
    autocmd!
    autocmd FileType help   nmap<buffer> q     <Cmd>close<CR>
    autocmd FileType help   nmap<buffer> <C-[> <Cmd>close<CR>
    autocmd FileType help   nmap<buffer> <Esc> <Cmd>close<CR>
augroup END

augroup FugitiveSettings
    autocmd!
    autocmd FileType fugitive :resize 12
augroup END

" }}}
