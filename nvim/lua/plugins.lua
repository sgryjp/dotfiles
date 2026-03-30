local gh = function(x) return "https://github.com/" .. x end

vim.pack.add({
  gh("echasnovski/mini.nvim"),
  gh("kyazdani42/nvim-web-devicons"),
  gh("nvim-lua/plenary.nvim"),
  gh("neovim/nvim-lspconfig"),
  gh("seblyng/roslyn.nvim"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("mason-org/mason.nvim"),
  gh("mason-org/mason-lspconfig.nvim"),
  { src = gh("catppuccin/nvim"), name = "catpuccin" },
  gh("folke/snacks.nvim"),
  gh("stevearc/quicker.nvim"),
  gh("tpope/vim-fugitive"),
  gh("elkasztano/nushell-syntax-vim"),
  gh("stevearc/aerial.nvim"),
  gh("stevearc/oil.nvim"),
  gh("stevearc/conform.nvim"),
  { src = gh("saghen/blink.cmp"), version = "v1.9.1" },
  gh("akinsho/toggleterm.nvim"),
  gh("hat0uma/csvview.nvim"),
})

-- Configure plugins (dedicated config files)
require("plugins/mini")
require("plugins/lsp")
require("plugins/roslyn")
require("plugins/mason")
require("plugins/snacks")
require("plugins/aerial")
require("plugins/conform")
require("plugins/toggleterm")

-- Configure plugins (simple setup calls)
require("quicker").setup({})
require("oil").setup({})
require("blink.cmp").setup({ signature = { enabled = true } })
require("csvview").setup({})
