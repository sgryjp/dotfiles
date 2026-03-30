local add, later = require("mini.deps").add, require("mini.deps").later

---@type { source: string, _require: string?, _opts: table? }[]
local specs = {
  { source = "echasnovski/mini.nvim", _require = "mini" },
  { source = "kyazdani42/nvim-web-devicons" },
  { source = "nvim-lua/plenary.nvim" },
  { source = "neovim/nvim-lspconfig", _require = "lsp" },
  { source = "seblyng/roslyn.nvim", _require = "roslyn" },
  { source = "nvim-treesitter/nvim-treesitter" },
  { source = "mason-org/mason.nvim", _require = "mason" },
  { source = "mason-org/mason-lspconfig.nvim" },
  { source = "catppuccin/nvim", name = "catpuccin" },
  { source = "folke/snacks.nvim", _require = "snacks" },

  { source = "nanozuki/tabby.nvim", _opts = {} },
  { source = "backdround/tabscope.nvim", _opts = {} },
  { source = "stevearc/quicker.nvim", _opts = {} },
  { source = "tpope/vim-fugitive" },
  { source = "elkasztano/nushell-syntax-vim" },
  { source = "stevearc/aerial.nvim", _require = "aerial" },
  { source = "stevearc/oil.nvim", _opts = {} },
  { source = "stevearc/conform.nvim", _require = "conform" },
  { source = "saghen/blink.cmp", checkout = "v1.9.1", _opts = { signature = { enabled = true } } },
  { source = "akinsho/toggleterm.nvim", _require = "toggleterm" },
  { source = "hat0uma/csvview.nvim", _opts = {} },
}

for _, spec in ipairs(specs) do
  add(spec)

  if spec._opts then
    local main = spec.source
    main = string.gsub(main, ".*/", "", 1)
    main = string.gsub(main, "%.nvim$", "", 1)
    later(function() require(main).setup(spec._opts) end)
  elseif spec._require then
    later(function() require("plugins/" .. spec._require) end)
  end
end
