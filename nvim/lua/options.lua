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

-- File & Edit settings
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = "ucs-bom,utf-8,cp932"
vim.opt.virtualedit = "block"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.clipboard = "unnamedplus"

-- UI & Appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.splitright = true
vim.opt.scrolloff = 2
vim.opt.updatetime = 500
vim.opt.wildmode = "longest:full"
vim.opt.mouse = "nv"
vim.opt.completeopt = "menuone,noinsert,noselect"
vim.opt.listchars = "tab:╌╌>,trail:␠"
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2,sbr"
vim.opt.showbreak = "↳"
if vim.version.ge(nvim_version, { 0, 8 }) then
  vim.opt.laststatus = 3
end
if vim.version.ge(nvim_version, { 0, 11 }) then
  vim.o.winborder = "rounded"
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
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    title = " Hover ",
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    title = " Signature Help ",
  })
end
if vim.version.ge(nvim_version, { 0, 11 }) then
  vim.diagnostic.config({
    virtual_text = true,
    virtual_lines = { current_line = true },
  })
end

-- Search settings
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = false

-- Indentation
vim.opt.shiftround = true
set_indent(4, true)

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

-- Misc
vim.opt.diffopt = "linematch:60,filler,closeoff"
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
