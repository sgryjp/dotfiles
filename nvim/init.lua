vim.cmd("runtime vimrc")

require("plugins/cmp")
require("plugins/gitsigns")
require("plugins/lualine")
require("plugins/lsp")
require("plugins/lsp_signature")
require("plugins/null-ls")
require("plugins/nvim-tree")
require("plugins/trouble") -- Must be before telescope
require("plugins/telescope")
