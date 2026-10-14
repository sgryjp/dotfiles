local nvim_version = vim.version()

-- Utility functions

--- Configure indentation.
--- @param width integer Indent size.
--- @param expand_tab boolean Whether to expand tab to spaces or not.
local function set_indent(width, expand_tab)
  vim.opt.expandtab = expand_tab
  vim.opt.tabstop = width
  vim.opt.softtabstop = width
  vim.opt.shiftwidth = width
end

--- Configure indentation for a specific filetype.
--- @param width integer Indent size.
--- @param expand_tab boolean Whether to expand tab to spaces or not.
--- @param augroup integer Autocmd group
--- @param filetypes string[] Filetypes to configure.
local function set_indent_ft(width, expand_tab, augroup, filetypes)
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = filetypes,
    callback = function() set_indent(width, expand_tab) end,
  })
end

-- File I/O
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "ucs-bom,utf-8,cp932"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = false

-- Editing
vim.opt.clipboard = "unnamedplus"
vim.opt.virtualedit = "block"

-- Search
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = false

-- UI & Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitright = true
vim.opt.scrolloff = 2
vim.opt.mouse = "nv"
vim.opt.listchars = "tab:╌╌>,trail:␠"
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2,sbr"
vim.opt.showbreak = "↳"
if vim.version.ge(nvim_version, { 0, 8 }) then
  vim.opt.laststatus = 3
end
if vim.version.ge(nvim_version, { 0, 11 }) then
  vim.o.winborder = "rounded"
end

-- Completion & File Browsing
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.wildmode = "longest:full"
vim.opt.wildignore = {
  "*.bak",
  "*.dll",
  "*.min.*",
  "*.o",
  "*.obj",
  "*.py[cod]",
  "*.so",
  "*.swp",
  "*~",
}

-- Diagnostics
if vim.version.ge(nvim_version, { 0, 11 }) then
  vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = { current_line = true },
  })
else
  vim.diagnostic.config({
    float = {
      border = "rounded",
      source = "if_many",
      focusable = true,
      max_width = 80,
      max_height = 20,
      title = " Diagnostic ",
      style = "minimal",
    },
  })
end

-- Indentation
vim.opt.shiftround = true
set_indent(4, true)

-- Behavior
vim.opt.updatetime = 500
vim.opt.diffopt = "linematch:60,filler,closeoff"

-- Filetype-specific settings
local indent_group = vim.api.nvim_create_augroup("indent", { clear = true })
set_indent_ft(8, false, indent_group, { "gitconfig", "make" })
set_indent_ft(4, false, indent_group, { "go" })
set_indent_ft(2, true, indent_group, {
  "css",
  "markdown",
  "html",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
})

-- Force enable syntax highlight for .razor files
-- (it is disabled by default for unknown reason as of 2025-12-23)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "razor",
  command = "lua vim.treesitter.start()",
})
-- Enable CSV view for .csv files automatically
vim.api.nvim_create_autocmd("FileType", {
  pattern = "csv",
  command = "CsvViewEnable",
})
