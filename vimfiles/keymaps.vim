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

" QuickFix and location list
nmap \q <Cmd>copen<CR>
nmap \l <Cmd>lopen<CR>

" Fuzzy finder
if !has('nvim')
    nmap         <C-p>      <Cmd>Files<CR>
endif

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

