-- File & Edit settings
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'ucs-bom,utf-8,cp932'
vim.opt.virtualedit = 'block'
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.clipboard = ''

-- UI & Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitright = true
vim.opt.scrolloff = 2
vim.opt.updatetime = 500
vim.opt.wildmode = 'longest:full'
vim.opt.mouse = ''
vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.listchars = 'tab:╌╌>,trail:␠'
vim.opt.breakindent = true
vim.opt.breakindentopt = 'shift:2,sbr'
vim.opt.showbreak = '↳'
vim.opt.laststatus = 3

-- Search settings
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = false

-- Indentation
vim.opt.shiftround = true

-- Misc
vim.opt.diffopt = 'linematch:60,filler,closeoff'
vim.opt.wildignore = {
    '*.bak',
    '*.dll',
    '*.min.*',
    '*.o',
    '*.obj',
    '*.py[cod]',
    '*.so',
    '*.swp',
    '*~',
}
