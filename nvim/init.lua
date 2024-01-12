-- Share configuration of VIM
vim.cmd("set runtimepath^=~/.vim runtimepath+=~/.vim/after")
vim.cmd("let &packpath=&runtimepath")
vim.cmd("runtime vimrc")

if not vim.g.vscode then
    require("plugins/cmp")
    require("plugins/conform")
    require("plugins/inlay-hints")
    require("plugins/gitsigns")
    require("plugins/lsp")
    require("plugins/lsp_signature")
    require("plugins/mini")
    require("plugins/nvim-tree")
    require("plugins/nvim-treesitter")
    require("plugins/symbols-outline")
end
