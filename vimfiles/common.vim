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

function! s:make_in_term_on_exit(j, d, e) abort
    " Scan error messages and put them into quickfix window
    cgetbuffer

    " Let 'q' or Esc to close the terminal window
    nmap<buffer> q     <Cmd>q<CR>
    nmap<buffer> <Esc> <Cmd>q<CR>
    nmap<buffer> <C-[> <Cmd>q<CR>

    " Put cursor to the bottom
    call cursor(9999, 9999)
endfunction

function! s:make_in_term(args) abort
    " Disable shellslash temporarily
    " TODO: Confirm this is right on Windows
    if exists('+shellslash')
        let l:shellslash = &shellslash
        set noshellslash
    endif

    try
        " Resolve command line to execute
        let l:cmdline = &makeprg
        if strlen(l:cmdline) == 0
            let &l:cmdline = 'make'
        endif
        let l:cmdline .= " " . a:args

        " Remember current errorformat for parsing result later as creating a
        " buffer may change it depending on configuration (e.g.: `autocmd`s).
        let l:errorformat = &errorformat

        " Execute it in a terminal buffer
        rightbelow split_f
        let l:options = {'on_exit': function("s:make_in_term_on_exit")}
        let l:job = termopen(l:cmdline, l:options)
    finally
        if exists('+shellslash')
            let &shellslash = l:shellslash
        endif
    endtry
endfunction

command! -nargs=* Make call s:make_in_term('<args>')

" }}}

" OS dependent workarounds {{{
if has('win32') || has('win64')
    set   termencoding=cp932
    " :PlugUpdate fails if `pwsh.exe` is set for shell...
    " https://www.reddit.com/r/neovim/comments/gbb2g3/wierd_vimplug_error_messages/g3n3vtl/
    "if executable('pwsh')
    "    set shell=pwsh.exe
    "endif

    " Use tee command on Windows too (should be bundled with Neovim)
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
if has('nvim-0.7')
    set laststatus=3
else
    set laststatus=2
endif
set   statusline =%n\ %<%f%R%M,%{&ff}%y%h%w%q
set   statusline+=%=\ %(%l,%c%V%)\ %p%%
set   statusline+=\ %#warningmsg#
set   statusline+=%*
set   scrolloff=2
set   updatetime=500
set   wildmenu
set   mouse=
set   completeopt=menuone,noinsert,noselect
set nolist
set   listchars=tab:╌╌>,trail:␠

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

" Misc. {{{
if executable('rg')
    set   grepprg=rg\ --vimgrep
endif
if has('nvim-0.9')
    set diffopt=linematch:60,filler,closeoff
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
if has('nvim')
    Plug 'catppuccin/nvim',         { 'tag': '*', 'as': 'catpuccin' }
    Plug 'nvim-lua/plenary.nvim' " for telescope.nvim
    Plug 'kyazdani42/nvim-web-devicons' " for telescope.nvim
    Plug 'MunifTanjim/nui.nvim'  " for neo-tree

    Plug 'rbong/vim-flog'
    Plug 'stevearc/oil.nvim', { 'branch': 'stable' }
    Plug 'echasnovski/mini.nvim', { 'branch': 'stable' }
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
    Plug 'nvim-neo-tree/neo-tree.nvim'
    Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }
    Plug 'williamboman/mason-lspconfig.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-ui-select.nvim'
    Plug 'ray-x/lsp_signature.nvim'
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-nvim-lua'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'onsails/lspkind-nvim'
    Plug 'stevearc/conform.nvim'
    Plug 'lewis6991/gitsigns.nvim', { 'tag': '*' }
    Plug 'simrat39/inlay-hints.nvim'
    Plug 'simrat39/symbols-outline.nvim'
else
    Plug 'sheerun/vim-polyglot'
    Plug 'lukas-reineke/indent-blankline.nvim'
    Plug 'joshdick/onedark.vim'
    Plug 'junegunn/fzf',                    { 'tag': '*', 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'editorconfig/editorconfig-vim',   { 'tag': '*' }
    Plug 'airblade/vim-gitgutter'
    Plug 'machakann/vim-sandwich',          { 'tag': '*' }
endif
call plug#end()

" }}}

syntax on

" Color scheme {{{
if !has('nvim')
    set t_Co=256
    if has('termguicolors')
        set termguicolors
    endif
    if findfile("colors/onedark.vim", &rtp) != ""
        colorscheme onedark
    endif
else
    if findfile("colors/catppuccin.vim", &rtp) != ""
        colorscheme catppuccin
    endif
endif

" }}} Color scheme

" (GitGutter) Use '≅' instead of '~_' for modified & removed line
let g:gitgutter_sign_modified_removed = '≅'

" Keymaps {{{

" Close auxiliary windows by <C-[> in normal mode.
if has("nvim")
    nmap <silent><C-[>      <Cmd>cclose<CR>
                            \ <Cmd>lclose<CR>
                            \ <Cmd>helpclose<CR>
endif

" Code-completion (not for Neovim as there will be nvim-cmp)
if !has("nvim")
    imap <silent><C-j>      <C-x><C-o>
endif

" Jump to prev/next l(ocation-list), q(uick-fix-list), (dia)g(nostic-items)
nmap         ]l         <Cmd>lnext<CR>
nmap         [l         <Cmd>lprevious<CR>
nmap         ]q         <Cmd>cnext<CR>
nmap         [q         <Cmd>cprevious<CR>
nmap <silent>[g         <Cmd>lua vim.diagnostic.goto_prev()<CR>
nmap <silent>]g         <Cmd>lua vim.diagnostic.goto_next()<CR>

" Go to something
nmap <silent>gD         <Cmd>lua vim.lsp.buf.declaration()<CR>
nmap <silent>gd         <Cmd>lua vim.lsp.buf.definition()<CR>
nmap <silent>gy         <Cmd>lua vim.lsp.buf.type_definition()<CR>
nmap <silent>gi         <Cmd>lua vim.lsp.buf.implementation()<CR>
nmap <silent>gr         <Cmd>lua vim.lsp.buf.references()<CR>

" Inspection
nmap <silent>K          <Cmd>lua vim.lsp.buf.hover()<CR>
nmap <silent><C-k>      <Cmd>lua vim.lsp.buf.signature_help()<CR>

" Refactoring (and formatting)
nmap \r <Cmd>lua vim.lsp.buf.rename()<CR>
nmap \a <Cmd>lua vim.lsp.buf.code_action()<CR>
nmap \f <Cmd>lua require'conform'.format({lsp_fallback = true})<CR>

" QuickFix and location list
nmap \q <Cmd>copen<CR>
nmap \l <Cmd>lopen<CR>

" Fuzzy finder and utility views
if has('nvim')
    nmap <silent><C-p>      <Cmd>lua MiniPick.builtin.files()<CR>

    nmap <silent><Space>b   <Cmd>lua MiniPick.builtin.buffers()<CR>
    nmap <silent><Space>f   <Cmd>lua MiniPick.builtin.files()<CR>
    nmap <silent><Space>p   <Cmd>lua MiniPick.builtin.grep_live()<CR>
    " nmap <silent><Space>s   <Cmd>lua MiniExtra.pickers.lsp({ scope = 'document_symbol' })<CR>
    nmap <silent><Space>S   <Cmd>lua MiniExtra.pickers.lsp({ scope = 'workspace_symbol' })<CR>
    nmap <silent><Space>d   <Cmd>lua MiniExtra.pickers.lsp({ scope = 'definition' })<CR>
    nmap <silent><Space>r   <Cmd>lua MiniExtra.pickers.lsp({ scope = 'references' })<CR>
    nmap <silent><Space>i   <Cmd>lua MiniExtra.pickers.lsp({ scope = 'implementation' })<CR>
    nmap <silent><Space>y   <Cmd>lua MiniExtra.pickers.lsp({ scope = 'type_definition' })<CR>
    nmap <silent><Space>g   <Cmd>lua MiniExtra.pickers.diagnostic()<CR>

    nmap <silent><Space>s   <Cmd>SymbolsOutline<CR>
else
    nmap         <C-p>      <Cmd>Files<CR>
endif

" File explorer (neo-tree)
nmap         <C-n>  <Cmd>Neotree<CR>

" Moves between windows
nmap         <C-h>  <C-w>h
nmap         <C-j>  <C-w>j
nmap         <C-k>  <C-w>k
nmap         <C-l>  <C-w>l
tmap         <Esc>  <C-\><C-n>
tmap         <C-[>  <C-\><C-n>
tmap         <C-h>  <C-\><C-n><C-w>h
tmap         <C-j>  <C-\><C-n><C-w>j
tmap         <C-k>  <C-\><C-n><C-w>k
tmap         <C-l>  <C-\><C-n><C-w>l

" Move forward/backward till next non-wsp at same the colum
" https://vi.stackexchange.com/a/693
nmap <silent>gJ     <Cmd>call search('\%' . virtcol('.') . 'v\S', 'W')<CR>
nmap <silent>gK     <Cmd>call search('\%' . virtcol('.') . 'v\S', 'bW')<CR>

" }}}

" Filetype specific configurations {{{
augroup PythonSettings
    " Using pytest for unit testing.
    " Note that setting errorformat for pytest is not necessary because it's
    " the same as flake8's which should be provided by vim-polyglot.
    autocmd!
    autocmd FileType python setlocal errorformat=%f:%l:\ %m
    autocmd FileType python setlocal foldmethod=indent
    autocmd FileType python setlocal foldlevel=999
    autocmd FileType python setlocal makeprg=python\ -m\ pytest\ $*
    autocmd FileType python nmap<buffer>    \t <Cmd>make<CR>
augroup END

augroup RustSettings
    autocmd!
    autocmd FileType rust   nmap<buffer>    \b :make build<CR>
    autocmd FileType rust   nmap<buffer>    \t :make test<CR>
augroup END

augroup GoSettings
    autocmd!
    autocmd FileType go     setlocal makeprg=go
    autocmd FileType go     nmap<buffer>    \b :make build ./...<CR>
    autocmd FileType go     nmap<buffer>    \t :make test ./...<CR>
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
